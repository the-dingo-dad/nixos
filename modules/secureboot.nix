{ pkgs, lib, ... }:
let
  reboot-windows = pkgs.writeShellApplication {
    name = "reboot-windows";
    runtimeInputs = [ pkgs.efibootmgr ];
    text = ''
      num=$(efibootmgr | grep -m1 "Windows Boot Manager" | sed -E 's/^Boot([0-9A-Fa-f]{4}).*/\1/')
      sudo efibootmgr --bootnext "$num"
      systemctl reboot
    '';
  };
in {
  # Lanzaboote replaces systemd-boot (it still uses systemd-boot's menu, just signed)
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";   # where sbctl keeps your keys
    configurationLimit = 8;          # max generations kept on the 1 GB ESP
  };

  environment.systemPackages = [ pkgs.sbctl pkgs.efibootmgr reboot-windows ];
}
