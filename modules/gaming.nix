{ lib, ... }: {
  jovian = {
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = true;            # boot straight into Gaming Mode
      user = "dingo-dad";
      desktopSession = "gnome";
    };
  };

  services.displayManager.gdm.enable = lib.mkForce false;  # GNOME
}
