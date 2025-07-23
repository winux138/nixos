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
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprfocus
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprgrass
      inputs.hyprland-hyprsplit.packages.${pkgs.system}.hyprsplit
    ];

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$menu" = "wofi --show drun";

      "monitor" = [
        "DP-4,2560x1440@59.95,1440x0,1.0,transform,1"
        "DP-5,2560x1440@59.95,2880x765,1.0"
        "DP-7,2560x1440@59.95,0x0,1.0,transform,1"
      ];

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 4, default"
          "borderangle, 0, 8, default"
          "fade, 1, 3, default"
          "workspaces, 1, 4, default"
        ];
      };

      decoration = {
        rounding = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.8;

        blur = {
          enabled = true;
          size = 3;
        };

        # shadow = {
        #   enabled = true;
        #   # color = rgb colors.base00;
        # };
      };

      dwindle = {
        force_split = 2;
        preserve_split = true;
      };

      env = [
        "XDG_DATA_DIRS,$HOME/.nix-profile/share"
        "XDG_SESSION_TYPE,wayland"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      input = {
        follow_mouse = 1;
        sensitivity = 0.0; # Set mouse sensitivity here
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      bind =
        [
          "$mod, S, exec, grimblast copy area"
          "$mod, P, exec, $menu"
          "$mod, return, exec, $terminal"
          "$mod SHIFT, L, exec, hyprlock"

          "$mod, C, killactive,"
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          "$mod, J, movefocus, r"
          "$mod, K, movefocus, l"
          "$mod SHIFT, J, movewindow, r"
          "$mod SHIFT, K, movewindow, l"

          "$mod, comma, focusmonitor, -1"
          "$mod, period, focusmonitor, +1"
          "$mod SHIFT, comma, movewindow, mon:-1"
          "$mod SHIFT, period, movewindow, mon:+1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, split:workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, split:movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      bindm = [
        # Bind mouse buttons to actions (e.g., move or resize windows)
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Nerd Font:size=12";
        dpi-aware = "yes";
      };

      security = {
        osc52 = "enabled";
      };

      colors = {
        # alpha = 0.9;
        foreground = "4c4f69";
        background = "eff1f5";

        regular0 = "5c5f77";
        regular1 = "d20f39";
        regular2 = "40a02b";
        regular3 = "df8e1d";
        regular4 = "1e66f5";
        regular5 = "ea76cb";
        regular6 = "179299";
        regular7 = "acb0be";

        bright0 = "6c6f85";
        bright1 = "d20f39";
        bright2 = "40a02b";
        bright3 = "df8e1d";
        bright4 = "1e66f5";
        bright5 = "ea76cb";
        bright6 = "179299";
        bright7 = "bcc0cc";

        cursor = "eff1f5 dc8a78";

        selection-foreground = "4c4f69";
        selection-background = "ccced7";

        search-box-no-match = "dce0e8 d20f39";
        search-box-match = "4c4f69 ccd0da";

        jump-labels = "dce0e8 fe640b";
        urls = "1e66f5";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
