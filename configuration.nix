# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  lib,
  # home-manager,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # (import "${home-manager}/nixos")
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      # efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    };
    # grub = {
    #   enable = true;
    #   efiSupport = true;
    #   #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    #   device = "nodev";
    #   useOSProber = true;
    # };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.enable = true;
  # Enable OpenGL
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
      vaapiIntel
      libvdpau-va-gl
      vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    # hardware.graphics since NixOS 24.11
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  }; # Force intel-media-driver

  hardware.bluetooth.enable = true;

  # # Load nvidia driver for Xorg and Wayland
  # services.xserver.videoDrivers = ["nvidia"];

  # hardware.nvidia = {
  #   # Modesetting is required.
  #   modesetting.enable = true;

  #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #   # Enable this if you have graphical corruption issues or application crashes after waking
  #   # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
  #   # of just the bare essentials.
  #   powerManagement.enable = false;

  #   # Fine-grained power management. Turns off GPU when not in use.
  #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  #   powerManagement.finegrained = false;

  #   # Use the NVidia open source kernel module (not to be confused with the
  #   # independent third-party "nouveau" open source driver).
  #   # Support is limited to the Turing and later architectures. Full list of
  #   # supported GPUs is at:
  #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
  #   # Only available from driver 515.43.04+
  #   open = false;

  #   # Enable the Nvidia settings menu,
  #   # accessible via `nvidia-settings`.
  #   nvidiaSettings = true;

  #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  hardware.keyboard.zsa.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  # programs.uwsm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.upower.enable = true;
  services.safeeyes.enable = true;

  # nixpkgs.overlays = [
  #   (import (
  #     builtins.fetchTarball {
  #       url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
  #     }
  #   ))
  # ];
  services.emacs = {
    enable = true;
    # package = pkgs.emacs-unstable;
    package = pkgs.emacs;
    # with pkgs; ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: [ epkgs.vterm epkgs.use-package ]));
  };

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ju = {
    isNormalUser = true;
    description = "ju";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      # thunderbird
    ];
    shell = pkgs.fish;
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      "mdjildafknihdffpkfmmpnpoiajfjnjd" # consent-o-matic
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "elifhakcjgalahccnjkneoccemfahfoa" # mardown here
    ];
    defaultSearchProviderSearchURL = "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
    defaultSearchProviderEnabled = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   withUWSM = true; # recommended for most users
  #   xwayland.enable = true; # Xwayland can be disabled.
  #   environment.sessionVariables.NIXOS_OZONE_WL = "1";
  #   plugins = [
  #     inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
  #   ];
  # };

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System-level GUI applications
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
    kdePackages.dolphin
    signal-desktop

    # Wayland/Hyprland essentials
    rofi-wayland
    rofi-emoji-wayland
    waybar
    hyprlock
    hypridle
    hyprpaper
    hyprsunset
    hyprpicker
    hyprpolkitagent
    hyprsome

    # System notifications and clipboard
    libnotify
    mako
    wl-clipboard

    # Qt/Wayland compatibility
    qt5.qtwayland
    qt6.qtwayland

    # Development tools (system-wide)
    nixd
    alejandra
    direnv
    gcc
    clang

    # Legacy packages that some might want system-wide
    vim # Keep as emergency editor
    git # Useful system-wide
    wget
    keymapp
    ungoogled-chromium
    qutebrowser
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  fonts.packages = with pkgs; [
    font-awesome
    dina-font
    liberation_ttf
    mplus-outline-fonts.githubRelease
    nerd-fonts.iosevka
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    proggyfonts
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  systemd.services.sshd = {
    wantedBy = lib.mkForce [];
    stopIfChanged = lib.mkForce true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    allowedUDPPorts = [ 5353 ]; # For device discovery
    allowedUDPPortRanges = [
      {
        from = 32768;
        to = 61000;
      }
    ]; # For Streaming
    allowedTCPPorts = [ 8010 ]; # For gnomecast server
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
