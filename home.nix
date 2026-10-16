{ config, pkgs, ... }:

{
  imports = [
#    ./firefox.nix
  ];

  home.username = "mk";
  home.homeDirectory = "/home/mk";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;


  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };


  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      btw = "echo i use nixos btw ";
    };
  };

programs.librewolf = {
  enable = true;
  settings = {
      # 1. WebRTC Lockdown
    "media.peerconnection.enabled" = false;
    "media.navigator.enabled" = false;
    "media.peerconnection.turn.disable" = true;

    # 2. Strict Quad9 DNS-over-HTTPS (DoH)
    "network.trr.mode" = 3; # Mode 3 forces DoH exclusively, no unencrypted fallback
    "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";

    # 3. Enhanced Anti-Fingerprinting (RFP)
    "privacy.resistFingerprinting.letterboxing" = true; # Adds window margins to mask screen resolution
    "dom.netinfo.enabled" = false; # Hides network interface details

    # 4. Stop Predictive Network Connections
    "network.dns.disablePrefetch" = true;
    "network.prefetch-next" = false;
  };

};

  home.packages = with pkgs; [
    # Your packages go here
  ];

  # -------------------------------------------------
  # Copy wallpaper INTO your home directory safely
  # -------------------------------------------------
  home.file."Pictures/wallpapers/wall.jpg".source = ./wallpapers/wall.jpg;
  home.file."Pictures/wallpapers/walltwo.png".source = ./wallpapers/walltwo.png;
  home.file."Pictures/wallpapers/wallthree.png".source = ./wallpapers/wallthree.png;

#  home.file.".config/hypr".source = ./hypr;  

#  home.file.".config/waybar".source = ./waybar; 

#  home.file.".config/wofi".source = ./wofi; 

#  home.file.".config/sway".source = ./sway;

# home.file.".config/kitty".source = ./kitty; 
#programs.kitty = {
#  enable = true;
#  settings = {
#    confirm_os_window_close = 0;
#  };
#};

#services.swaync = {
#  enable = true;
#  settings = {
#    timeout = 5;
#    timeout-low = 5;
#    timeout-critical = 0;
#  };
#};

}


