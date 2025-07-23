{
  config,
  pkgs,
  ...
} @ inputs: {
  home.username = "ju";
  home.homeDirectory = "/home/ju";
  home.stateVersion = "25.05";

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      # pkgs.hyprlandPlugins.hyprsplit
      # pkgs.hyprlandPlugins.hyprexpo
      # pkgs.hyprlandPlugins.hyprfocus
      # pkgs.hyprlandPlugins.hyprgrass
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-hyprsplit.packages.${pkgs.system}.hyprsplit
    ];
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Nerd Font:size=12";
        dpi-aware = "yes";
        initial-color-theme = "catppuccin-latte";
      };

      security = {
        osc52 = "enabled";
      };

      colors = {
        alpha = 0.9;
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
