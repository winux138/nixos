{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixosConfig.desktop.windowManager.hyprland;
in
{
  options.nixosConfig.desktop.windowManager.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "hyprland-uwsm";
    };

    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      wdisplays
      nwg-displays
      hyprlock
      hypridle
      hyprpaper
      hyprsunset
      hyprpicker
      hyprpolkitagent
    ];
  };
}
