{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, lanzaboote, ... }: {
    nixosConfigurations.dingo-os = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/dingo-os/configuration.nix
        lanzaboote.nixosModules.lanzaboote
        ./modules/secureboot.nix
        ./modules/dev.nix
        ./modules/dual-boot.nix
      ];
    };
  };
}
