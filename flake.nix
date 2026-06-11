{
  description = "NixOS configuration for my Homelab!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      inventory = import ./inventory;
      modules = [ ./modules ];
    in
    {

      nixosConfigurations = {
        gw-nbg = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };

          modules = modules ++ [
            disko.nixosModules.disko
            ./hosts/gw-nbg
          ];
        };
      };
    };
}
