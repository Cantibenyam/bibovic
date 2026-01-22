{
  description = "My NixOS Hyprland Rice";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # Replace 'my-hostname' with your actual hostname 
    # (found inside configuration.nix under networking.hostName)
    nixosConfigurations.nyam = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
