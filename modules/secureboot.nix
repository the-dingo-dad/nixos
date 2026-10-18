{ pkgs, lib, ... }:
{
  # Lanzaboote replaces systemd-boot (it still uses systemd-boot's menu, just signed)
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";   # where sbctl keeps your keys
    configurationLimit = 8;          # max generations kept on the 1 GB ESP
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
