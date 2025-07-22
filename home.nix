{config, pkgs, ...}@inputs:

{
  home.username = "ju";
  home.homeDirectory = "/home/ju";
  home.stateVersion = "25.05";

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
        pkgs.hyprlandPlugins.hyprsplit
        pkgs.hyprlandPlugins.hyprexpo
        # pkgs.hyprlandPlugins.hyprfocus
        pkgs.hyprlandPlugins.hyprgrass
    ];
  };


  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Nerd Font:size=16";
        dpi-aware = "yes";
      };

      security = {
        osc52 = "enabled";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
 
