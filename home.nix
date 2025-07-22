{config, pkgs, ...}@inputs:

{
  home.username = "ju";
  home.homeDirectory = "/home/ju";
  # home.stateVersion = "25.05";

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
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
