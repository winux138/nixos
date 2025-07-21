{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.nixosConfig.global;
in {
  options.nixosConfig.global = {
    enable = mkEnableOption "Global system settings";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
    };

    environment.systemPackages = with pkgs; [
      # TODO: Move out of here
      git
    ];

    fonts.packages = with pkgs; [
      font-awesome
      nerd-fonts.iosevka
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];

    nix = {
      # Disable channel since we use flakes
      channel.enable = false;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    # Set timezone
    time.timeZone = "Europe/Zurich";

    # Needed by home-manager
    programs.dconf.enable = true;

    # Enable ssh by default
    nixosConfig.system.openssh.enable = mkDefault false;

    # TODO: renenable later
    # Enable theming
    # nixosConfig.theme.enable = mkDefault true;

    # Internationalization
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_MEASUREMENT = "fr_CH.UTF-8";
        LC_MONETARY = "fr_CH.UTF-8";
        LC_NUMERIC = "fr_CH.UTF-8";
        LC_PAPER = "fr_CH.UTF-8";
      };
    };
  };
}
