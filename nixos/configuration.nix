# _____ _            _____ _ _        _____        ____        _       _____ _                         _    _ _  
#|_   _| |__   ___  |  ___(_) | ___  |_   _|__    |  _ \ _   _| | ___ |_   _| |__   ___ _ __ ___      / \  | | |TM
#  | | | '_ \ / _ \ | |_  | | |/ _ \   | |/ _ \   | |_) | | | | |/ _ \  | | | '_ \ / _ \ '_ ` _ \    / _ \ | | |
#  | | | | | |  __/ |  _| | | |  __/   | | (_) |  |  _ <| |_| | |  __/  | | | | | |  __/ | | | | |  / ___ \| | |
#  |_| |_| |_|\___| |_|   |_|_|\___|   |_|\___/   |_| \_\\__,_|_|\___|  |_| |_| |_|\___|_| |_| |_| /_/   \_\_|_|
#                                                                                                          
#--------------------------------------------------------------------------------------------------------------------

#NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,  ... }:

{

#dual dots means go back one
imports =
[
  ./hardware-configuration.nix
  ./hyprland.nix
  ./music.nix
  ./sddmconf.nix
];


nix = {
  settings = {
    experimental-features = [  "nix-command"  "flakes"  ];
    auto-optimise-store = true;
  };
};

nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};

nix.registry.nixpkgs.flake = inputs.nixpkgs;

programs.bash.shellAliases = {
 rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
 testbuild = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
 update-system = "cd /etc/nixos && nix flake update && sudo nixos-rebuild test --flake /etc/nixos#nixos";
};


  boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
  systemd-boot.consoleMode = "5";
  systemd-boot.configurationLimit = 3;
  timeout = 2;
  };

  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelParams = [
    "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" 
    "amd_pstate=active"
    "splash" 
    "quiet" "loglevel=1" "rd.systemd.show_status=false" "rd.udev.log_level=1" "vt.global_cursor_default=0"
#    "video=1920x1080" 
  ];

  powerManagement.cpuFreqGovernor = "schedutil";    #powersave works to
  networking.hostName = "nixos";
  # networking.wireless.enable = true; 
#--------------------------------------------------------------------------------------------------------------------
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.enable = true;

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [

    ];

    allowedUDPPorts = [

    ];
  };

#--------------------------------------------------------------------------------------------------------------------
  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

#--------------------------------------------------------------------------------------------------------------------
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
#    forceFullCompositionPipeline = true;
    nvidiaSettings = true;

    prime = {
    sync.enable = true;
#    offload = {
#      enable = true;
#      enableOffloadCmd = true;
#    };
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  };

  services.power-profiles-daemon.enable = true;


#--------------------------------------------------------------------------------------------------------------------
  # Enable the KDE Plasma Desktop Environment.
services.desktopManager.plasma6.enable = true;
services.displayManager.sddm.enable = true;
#--------------------------------------------------------------------------------------------------------------------

  services.xserver.xkb = {
    layout = "se";
    variant = "nodeadkeys";
  };

  console.keyMap = "sv-latin1";
  
  services.printing.enable = true;

#  services.pipewire.systemWide = false;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
#    jack.enable = true;
#    media-session.enable = true;
  };

#  services.xserver.libinput.enable = true;
  services.ratbagd.enable = true;

#--------------------------------------------------------------------------------------------------------------------

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."mk" = {
    isNormalUser = true;
    description = "Mehmet Akkus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
#--------------------------------------------------------------------------------------------------------------------

 programs.firefox.enable = true;
 
 programs.steam = {
  enable = true;
  gamescopeSession.enable = true;
  };
#  services.n8n.enable = true;
  programs.gamemode.enable = true;
  security.apparmor.enable = true;
#--------------------------------------------------------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
   enable = true;
   extraPortals = with pkgs; [
     xdg-desktop-portal-hyprland
     xdg-desktop-portal-gtk
   ];
 };
#--------------------------------------------------------------------------------------------------------------------

  # $ nix search wget
  environment.systemPackages = with pkgs; [
   terminus_font
   vim 
   neovim
   wget
   git
   curl
   gcc # gcc -std=c2x -Wall -Wextra -Wpedantic -Wshadow -Wconversion -g -O0 path -o result
   nixfmt
   clang-tools
   gdb
   valgrind
   micro
   vscodium
   zeal
   dasht
 
   htop
   btop
   iw
   pciutils
   usbutils
   ethtool
   mangohud
   bubblewrap
   fzf
   jq
   networkmanager
   wireplumber
#   bluetoothctl
   pavucontrol
   pipewire

   vulkan-tools
   vulkan-loader
   libGL
   nvidia-vaapi-driver

   piper

#   arduino-ide
#   platformio
#   esptool
#   minicom  

   fastfetch
   cava
   mapscii

   mpv
   yt-dlp

   cmatrix
   asciiquarium
   nerd-fonts.jetbrains-mono
   
# hyprland
   libnotify
   awww  #swww
   wofi
   ranger
   termusic
   mako
   kitty
   waybar
   hyprpaper
   hyprlock
   swaynotificationcenter
   hypridle
   wl-clipboard
   cliphist
   wtype
   thunar
   waybar
   jetbrains-mono
   blueman
   networkmanagerapplet
   power-profiles-daemon
   brightnessctl


   prismlauncher
#   kdialog
#   xdialog
   zenity
   temurin-bin-21
   anki
];
#--------------------------------------------------------------------------------------------------------------------

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
