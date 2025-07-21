{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.nixosConfig.system.programs;
in {
  options.nixosConfig.system.programs = {
    enable = mkOption {
      default = true;
      description = "Whether to enable programs";
      type = types.bool;
    };
  };

    environment.systemPackages = with pkgs; [
      bat
      nixd
      alejandra
      gcc
      clang
      fzf
      fastfetch
      bottom
      htop
      tmux
      vim
      wget
      ouch
      neovim
      git
      lazygit
      curl
      wget
      helix
      eza
      ripgrep
      fd
    ];
  };
}
