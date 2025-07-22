{config, pkgs, ...}:

{
  home.username = "ju";
  home.homeDirectory = "/home/ju";
  home.stateVersion = "25.05";

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
