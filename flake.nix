{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, lanzaboote, jovian, ... }: {
    nixosConfigurations.dingo-os = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/dingo-os/configuration.nix
        lanzaboote.nixosModules.lanzaboote
        jovian.nixosModules.default
        ./modules/secureboot.nix
        ./modules/dual-boot.nix
        ./modules/dev.nix
        ./modules/gaming.nix
      ];
    };
  };
}
