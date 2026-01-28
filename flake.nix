{
  description = "nyam's NixOS Hyprland Rice";

  inputs = {
    # Unstable for your System/Hyprland (Bleeding Edge)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #stylix.url = "github:danth/stylix";
    # Stable for Prisma (Pins this to Prisma v5 to match your project)
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    
    # We create a separate package set for the stable version
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
  in
  {
    # --- System Configuration ---
    nixosConfigurations.nyam = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nyam = import ./home.nix;
          #home-manager.sharedModules = [stylix.homeManagerModules.stylix];
        }

        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              bibtool = prev.bibtool.overrideAttrs (oldAttrs: {
                # Force GCC to relax strictness for this specific package
                env = (oldAttrs.env or {}) // {
                  NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
                };
              });
            })
          ];
        })
      ];
    };

    # --- Home Manager Configuration ---
    homeConfigurations."nyam" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home.nix ];
    };

    # --- DEV SHELL (Fixed for Prisma 5) ---
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.nodejs_20
        pkgs.nodePackages.pnpm
        pkgs.openssl
        # Use the STABLE Prisma (v5) so the CLI matches your package.json
        pkgs-stable.nodePackages.prisma
      ];

      # Point environment variables to the STABLE (v5) engines
      env = {
        PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs-stable.prisma-engines}/lib/libquery_engine.node";
        PRISMA_QUERY_ENGINE_BINARY = "${pkgs-stable.prisma-engines}/bin/query-engine";
        PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs-stable.prisma-engines}/bin/schema-engine";
        PRISMA_FMT_BINARY = "${pkgs-stable.prisma-engines}/bin/prisma-fmt";
      };

      shellHook = ''
        export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}:$LD_LIBRARY_PATH
        echo "Prisma Environment Loaded (Pinned to v5)"
      '';
    };
  };
}
