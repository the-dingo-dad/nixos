{ pkgs, ... }:
let
  # Runs as root: sets Windows as the next boot, then reboots
  reboot-windows-root = pkgs.writeShellApplication {
    name = "reboot-windows-root";
    runtimeInputs = with pkgs; [ efibootmgr gnugrep gnused systemd ];
    text = ''
      num=$(efibootmgr | grep -m1 "Windows Boot Manager" | sed -E 's/^Boot([0-9A-Fa-f]{4}).*/\1/')
      efibootmgr --bootnext "$num"
      systemctl reboot
    '';
  };

  # What you actually run - hands off to the root script via passwordless sudo
  reboot-windows = pkgs.writeShellApplication {
    name = "reboot-windows";
    text = ''exec /run/wrappers/bin/sudo ${reboot-windows-root}/bin/reboot-windows-root'';
  };

  # Makes it show up in app launchers and Steam's "Add a Non-Steam Game" list
  reboot-windows-desktop = pkgs.makeDesktopItem {
    name = "reboot-windows";
    desktopName = "Reboot to Windows";
    exec = "reboot-windows";
    icon = "system-reboot";
    categories = [ "System" ];
  };
in {
  environment.systemPackages = [ reboot-windows reboot-windows-desktop pkgs.efibootmgr ];

  security.sudo.extraRules = [{
    users = [ "dingo-dad" ];
    commands = [{
      command = "${reboot-windows-root}/bin/reboot-windows-root";
      options = [ "NOPASSWD" ];
    }];
  }];
}
