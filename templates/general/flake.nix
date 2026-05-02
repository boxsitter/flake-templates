{
  description = "General Development Environment";

  # ─────────────────────────────────────────────────────────────────────────────
  # AGENT SETUP INSTRUCTIONS
  # ─────────────────────────────────────────────────────────────────────────────
  # This is a blank Nix flake for an isolated dev environment. When setting up
  # a project, follow these steps:
  #
  # STEP 1 — Identify the required language runtimes and tools, then add them to
  #           buildInputs below. Use `nix search nixpkgs <name>` or browse
  #           https://search.nixos.org/packages to find exact package names.
  #
  # STEP 2 — If the language uses a package manager (npm, pip, cargo, etc.),
  #           add the relevant install/sync logic to shellHook (see patterns in
  #           the nodejs and python templates for reference).
  #
  # STEP 3 — If runtime system libraries are needed (e.g. for Python C-extension
  #           wheels: openssl, zlib, libffi), add them to buildInputs AND export
  #           LD_LIBRARY_PATH in shellHook using pkgs.lib.makeLibraryPath.
  #           See the python template for a full example.
  #
  # STEP 4 — Set the description string to something meaningful for the project.
  #
  # STEP 5 — After editing, rebuild the environment:
  #             nix develop
  #           direnv will reload automatically if .envrc exists and is allowed.
  #
  # SYSTEM NOTE — `system` is pinned to x86_64-linux. Change it to match the
  #               target machine (see options below). For a multi-platform flake
  #               replace the let binding with flake-utils or flake-parts.
  # ─────────────────────────────────────────────────────────────────────────────

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      # Platform options:
      #   x86_64-linux    — most Linux desktops and CI runners
      #   aarch64-linux   — Raspberry Pi 4/5, ARM Linux servers
      #   x86_64-darwin   — Intel Mac
      #   aarch64-darwin  — Apple Silicon Mac
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # ── Language runtimes — uncomment / add as needed ────────────────────
          # nodejs_22           # Node.js 22 LTS (includes npm)
          # python311           # Python 3.11
          # rustup              # Rust toolchain manager (rustc, cargo via rustup)
          # go                  # Go
          # jdk21               # Java 21 (OpenJDK)
          # ruby_3_3            # Ruby 3.3
          # php83               # PHP 8.3
          # dotnet-sdk_8        # .NET 8 SDK

          # ── Build tools ──────────────────────────────────────────────────────
          # gnumake             # make
          # cmake
          # pkg-config
          # gcc

          # ── System libraries (needed by compiled language extensions) ────────
          # openssl             # TLS — required by many HTTP clients
          # zlib                # zlib compression
          # libffi              # Foreign Function Interface
          # sqlite              # SQLite C library

          # ── Databases / services ─────────────────────────────────────────────
          # postgresql          # Postgres client + server binaries
          # redis               # Redis server

          # ── Other tools ──────────────────────────────────────────────────────
          # docker-compose      # Multi-container Docker apps
          # awscli2             # AWS CLI v2
          # terraform           # Infrastructure as code
        ];

        shellHook = ''
          # ── Environment variables — uncomment and set as needed ──────────────
          # export APP_ENV="development"
          # export PORT="8080"
          # export DATABASE_URL="postgresql://localhost/mydb"
          # export API_KEY=""   # prefer .env for secrets — it is gitignored

          # ── Language-specific setup ──────────────────────────────────────────
          # Add initialisation logic here (venv creation, npm install, etc.).
          # Refer to the nodejs or python templates for ready-made patterns.

          echo "Dev environment ready"
        '';
      };
    };
}
