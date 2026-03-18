{
  description = "Node.js Development Environment";

  # REQUIREMENTS:
  # - A package.json file should exist. Use package-lock.json to pin dependencies
  #   for reproducibility. Generate it after installing your packages:
  #
  #     npm install <package>
  #     # package-lock.json is created/updated automatically
  #
  # USAGE:
  # 1. Run: nix develop
  # 2. Install packages: npm install
  # 3. After adding new packages: npm install <package>

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";  # Options: x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Node.js runtime - adjust version as needed
          nodejs_22  # LTS; alternatives: nodejs_20, nodejs_18

          # Uncomment additional tools as needed:
          # nodePackages.typescript    # TypeScript compiler
          # nodePackages.eslint        # Linter
          # nodePackages.prettier      # Code formatter
        ];

        shellHook = ''
          if [ ! -f package.json ]; then
            echo ""
            echo "WARNING: package.json not found!"
            echo "   Initialise a project to track your dependencies:"
            echo "     npm init"
            echo ""
          else
            # Warn if no lockfile exists (unpinned dependencies)
            if [ ! -f package-lock.json ]; then
              echo ""
              echo "WARNING: package-lock.json not found."
              echo "   Run 'npm install' to generate a lockfile for reproducibility."
              echo ""
            fi

            # Install node_modules only when package-lock.json (or package.json) has changed
            LOCK_FILE="package-lock.json"
            if [ ! -f "$LOCK_FILE" ]; then
              LOCK_FILE="package.json"
            fi
            LOCK_HASH=$(sha256sum "$LOCK_FILE" | cut -d' ' -f1)
            HASH_FILE="node_modules/.install_hash"

            if [ ! -d node_modules ] || [ ! -f "$HASH_FILE" ] || [ "$(cat $HASH_FILE)" != "$LOCK_HASH" ]; then
              echo "Installing dependencies..."
              npm install --silent
              echo "$LOCK_HASH" > "$HASH_FILE"
            fi
          fi

          # Project-specific environment variables — uncomment and set as needed:
          # export NODE_ENV="development"
          # export PORT="3000"
          # export DATABASE_URL="postgresql://localhost/mydb"

          echo "Node.js environment ready  ($(node --version), npm $(npm --version))"
        '';
      };
    };
}
