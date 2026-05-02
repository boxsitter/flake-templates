# Nix Flake Dev Environment — Agent Instructions

This project uses a **Nix flake** to provide a fully isolated, reproducible
development environment. The entry point is `flake.nix`. All tooling is
declared there; nothing should be installed globally on the host.

---

## How the environment works

| File | Purpose |
|------|---------|
| `flake.nix` | Declares all tools and env-var setup via `devShells` |
| `.envrc` | Tells direnv to activate the flake shell automatically on `cd` |
| `.gitignore` | Excludes Nix build outputs (`result/`), `.direnv/`, and `.env` |

When a developer runs `nix develop` (or direnv auto-activates), Nix builds the
shell described in `devShells.<system>.default`, runs `shellHook`, and drops
the user into a shell that has exactly the declared packages on `$PATH`.

---

## Adding a dependency

1. **Find the package name**
   ```
   nix search nixpkgs <keyword>
   ```
   or browse <https://search.nixos.org/packages>.

2. **Add it to `buildInputs`** inside `pkgs.mkShell { … }` in `flake.nix`:
   ```nix
   buildInputs = with pkgs; [
     git curl jq
     nodejs_22   # ← add new packages here
   ];
   ```

3. **Rebuild** — direnv reloads automatically; otherwise run:
   ```
   nix develop
   ```

---

## Setting up a language environment

### Node.js / npm
```nix
buildInputs = with pkgs; [ nodejs_22 ];
```
Add to `shellHook` to auto-install on first use (copy from the `nodejs`
template for the hash-based install guard pattern).

### Python (with venv)
```nix
buildInputs = with pkgs; [ python311 ];
```
Add venv creation + `pip install -r requirements.txt` logic to `shellHook`.
If C-extension wheels are needed, also add system libraries
(`openssl`, `zlib`, `libffi`, etc.) and export `LD_LIBRARY_PATH` via
`pkgs.lib.makeLibraryPath`. See the `python` template for the full pattern.

### Rust
```nix
buildInputs = with pkgs; [ rustup ];
```
Add `rustup toolchain install stable` to `shellHook` if no `rust-toolchain`
file exists yet.

### Go
```nix
buildInputs = with pkgs; [ go ];
```

---

## Changing the target platform

The `system` variable in `flake.nix` is pinned to `x86_64-linux`. Change it
to match the machine:

| Value | Machine |
|-------|---------|
| `x86_64-linux` | Most Linux desktops and CI |
| `aarch64-linux` | Raspberry Pi 4/5, ARM Linux servers |
| `x86_64-darwin` | Intel Mac |
| `aarch64-darwin` | Apple Silicon Mac |

For a flake that must work on multiple platforms at once, replace the `let`
binding with [flake-utils](https://github.com/numtide/flake-utils) or
[flake-parts](https://flake.parts).

---

## Environment variables

Declare them in `shellHook` for non-secret values:
```bash
export APP_ENV="development"
export PORT="8080"
```

For secrets, use a `.env` file (already gitignored). Load it in `shellHook`:
```bash
[ -f .env ] && set -a && source .env && set +a
```

---

## Common pitfalls

- **`error: experimental features disabled`** — add to `/etc/nix/nix.conf`:
  `experimental-features = nix-command flakes`
- **direnv not reloading** — run `direnv allow` after editing `.envrc` or
  `flake.nix`.
- **`ImportError` for a Python C extension** — a system library is missing
  from `buildInputs` or `LD_LIBRARY_PATH` is not set. See the python template.
- **Wrong architecture** — make sure `system` matches `uname -m` output.
