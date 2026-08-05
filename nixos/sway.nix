#_____ _ _____ _____ _
#|_ _||__ ___ | ___| ___ __ _ _ __ ___ ___ | ___(_)_ __
# | | | '_ \ / _ \ | |_ / _ \/ _` | '__/ _ \ / _ \ | |_ | \ \/ /
# | | | | | | __/ | _| | __/ (_| | | | (_) | (_) | | _| | |> <
# |_| |_| |_|\___| |_| \___|\__,_|_| \___/ \___/ |_| |_/_/\_\
#
#------------------------------------------------------------------------------
# sway.nix
#
# System-level SwayFX configuration.
#
# Keep user configuration (keybinds, Waybar config, swayidle config,
# swaylock config, wallpapers, etc.) in Home Manager.
#------------------------------------------------------------------------------

{ config, pkgs, ... }:

{

  ##########################################################################
  ## SwayFX
  ##########################################################################

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;

    # Adds GTK environment variables automatically.
    wrapperFeatures.gtk = true;


    # Uncomment only if Sway refuses to start because of Nvidia.
    # extraOptions = [ "--unsupported-gpu" ];
  };

  ##########################################################################
  ## Packages
  ##########################################################################

  environment.systemPackages = with pkgs; [

    # DO NOT include swayfx here.
    # programs.sway.package already installs it.
    # swayfx

    ## Core utilities
    kitty
    waybar
    fuzzel
    wlogout

    ## Lock / idle
    swaylock-effects
    swayidle

    ## Clipboard
    wl-clipboard
    cliphist

    ## Screenshots
    grim
    slurp

    ## Notifications
    swaynotificationcenter

    ## Utilities
    brightnessctl
    playerctl

    ## Authentication agent
    polkit_gnome
  ];

  ##########################################################################
  ## Portals
  ##########################################################################

  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk

      # Uncomment only if an application specifically requires it.
      # xdg-desktop-portal
    ];
  };

  ##########################################################################
  ## Authentication
  ##########################################################################

  security.polkit.enable = true;

  security.pam.services.swaylock = {};

  ##########################################################################
  ## Fonts
  ##########################################################################

  fonts.fontconfig.enable = true;

  ##########################################################################
  ## User Services
  ##########################################################################


  ##########################################################################
  ## Notes
  ##########################################################################

  # These belong in configuration.nix instead:
  #
  # hardware.graphics.enable = true;
  #
  # boot.kernelParams = [
  #   "nvidia-drm.modeset=1"
  #   "nvidia-drm.fbdev=1"
  # ];
  #
  # hardware.nvidia = {
  #   ...
  # };
  #
  # services.pipewire = {
  #   ...
  # };
}
