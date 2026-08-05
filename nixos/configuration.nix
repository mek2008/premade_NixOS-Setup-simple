# _____ _            _____ _ _        _____        ____        _       _____ _                         _    _ _  
#|_   _| |__   ___  |  ___(_) | ___  |_   _|__    |  _ \ _   _| | ___ |_   _| |__   ___ _ __ ___      / \  | | |TM
#  | | | '_ \ / _ \ | |_  | | |/ _ \   | |/ _ \   | |_) | | | | |/ _ \  | | | '_ \ / _ \ '_ ` _ \    / _ \ | | |
#  | | | | | |  __/ |  _| | | |  __/   | | (_) |  |  _ <| |_| | |  __/  | | | | | |  __/ | | | | |  / ___ \| | |
#  |_| |_| |_|\___| |_|   |_|_|\___|   |_|\___/   |_| \_\\__,_|_|\___|  |_| |_| |_|\___|_| |_| |_| /_/   \_\_|_|
#                                                                                                          
#--------------------------------------------------------------------------------------------------------------------

#NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs,  ... }:

{
#dual dots means go back one
imports =
[
  ./hardware-configuration.nix
#  ./hyprland.nix
  ./music.nix
  ./sddmconf.nix
  ./security.nix
#  ./fnmullvad.nix
#  ./sway.nix
#  ./customKernel.nix
];

#boot.kernelPackages = pkgs.linuxPackages_hardend; why did they stop working on it :(

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
rebuild = "nixos-rebuild switch --flake /etc/nixos#nixos && printf '\\033[1;94mNew \\033[94mbuild successful\\033[0m\\n'";
testbuild = "nixos-rebuild test --flake /etc/nixos#nixos && printf 'Test built successful and \\033[32mactive\\033[0m\\033[0m but \\033[1;5;91mNOT PERMANENT\\033[0m\\n'";
update-system = "cd /etc/nixos && nix flake update && nixos-rebuild test --flake /etc/nixos#nixos && printf '\\033[32mUpdate successful\\033[0m and dont forget to \\033[1;5;91mREBUILD\\033[0m\\n'";
system-update = "cd /etc/nixos && nix flake update && nixos-rebuild test --flake /etc/nixos#nixos && printf '\\033[32mUpdate successful\\033[0m and dont forget to \\033[1;5;91mREBUILD\\033[0m\\n'";

};

#--------------------------------------------------------------------------------------------------------------------

  services.fwupd.enable = true;

  boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
  systemd-boot.consoleMode = "5";
  systemd-boot.configurationLimit = 3;
  timeout = 0;
  systemd-boot.editor = false;
  };

  # UEFI mode required — legacy BIOS boot can't use this at all).
#  boot.loader.systemd-boot.enable = lib.mkForce false;
#  boot.lanzaboote = {
#    enable = true;
#    pkiBundle = "/etc/secureboot";
#  };
#  environment.systemPackages = [ pkgs.sbctl ];
# !!! sbctl create-keys     sbctl enroll-keys --microsoft    sbctl verify


  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };

  boot.kernelModules = [ "msi_ec" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.cpu.amd.updateMicrocode = true;


  boot.kernelParams = [
    "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" 
    "amd_pstate=active"
    "splash" 
    "quiet" "loglevel=3" "systemd.show_status=3" "rd.systemd.show_status=true" "rd.udev.log_level=3" "vt.global_cursor_default=0" 
    "plymouth.ignore-serial-consoles" "fbcon=nodefer"
    "acpi_enforce_resources=lax"
#    "video=1920x1080" 
#    "video=CMN1521:panel_orientation=normal"
 
    "slab_nomerge"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_alloc.shuffle=1"
    "randomize_kstack_offset=on"
    "audit_backlog_limit=8192"
    "mitigations=auto" # Spectre/Meltdown mitigations, SMT stays on (no nosmt — that's the real FPS tax)
#    "lockdown=integrity"  #no signed GPU driver
  ];

  services.power-profiles-daemon.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";    #powersave works to
#--------------------------------------------------------------------------------------------------------------------
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.enable = true;
  networking.hostName = "nixos";
#  networking.wireless.enable = true; 

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

  fonts.fontconfig.enable = true; #suprisingly important

#--------------------------------------------------------------------------------------------------------------------
#  services.xserver.enable = true;
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

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    algorithm = "zstd";
  };

#--------------------------------------------------------------------------------------------------------------------
  # Enable the KDE Plasma Desktop Environment.
services.desktopManager.plasma6.enable = true;
services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
};
#--------------------------------------------------------------------------------------------------------------------

  services.xserver.xkb = {
    layout = "se";
    variant = "nodeadkeys";
  };

  console.keyMap = "sv-latin1";
  
  services.printing.enable = true;

#  services.pipewire.systemWide = false;
  services.pulseaudio.enable = false;
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

hardware.bluetooth = {
  enable = true;
  powerOnBoot = false;
};

#--------------------------------------------------------------------------------------------------------------------

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."mk" = {
    isNormalUser = true;
    description = "Mehmet Akkus";
    extraGroups = [ 
      "networkmanager"
#      "wheel" 
    ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
#--------------------------------------------------------------------------------------------------------------------

 programs.firefox.enable = true;
 
 programs.steam = {
  enable = true;
#  gamescopeSession.enable = true;
  };
#  services.n8n.enable = true;
  programs.gamemode.enable = true;
#--------------------------------------------------------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
   enable = true;
   wlr.enable = true;
   extraPortals = with pkgs; [
     xdg-desktop-portal-gtk
     xdg-desktop-portal-wlr
   ];
 };
#--------------------------------------------------------------------------------------------------------------------

  # $ nix search wget
  environment.systemPackages = with pkgs; [
#   sbctl
   lynis
   vulnix
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
   wireguard-tools
   bubblewrap
   firejail


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
   ranger
   termusic
   wl-clipboard
   cliphist
   jetbrains-mono
#   blueman
#   networkmanagerapplet
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
