{ config, pkgs, ... }:

{
  home.username = "mk";
  home.homeDirectory = "/home/mk";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      btw = "echo i use nixos btw ";
    };
  };

  home.packages = with pkgs; [
    # Your packages go here
  ];

  # -------------------------------------------------
  # Copy wallpaper INTO your home directory safely
  # -------------------------------------------------
  home.file."Pictures/wallpapers/wall.jpg".source = ./home/wallpapers/wall.jpg;
  home.file."Pictures/wallpapers/walltwo.png".source = ./home/wallpapers/walltwo.png;
  home.file."Pictures/wallpapers/wallthree.png".source = ./home/wallpapers/wallthree.png;

  home.file.".config/hypr".source = ./hypr;  

  home.file.".config/waybar".source = ./waybar; 

  home.file.".config/wofi".source = ./wofi; 


home.file.".config/kitty".source = ./kitty; 
#programs.kitty = {
#  enable = true;
#  settings = {
#    confirm_os_window_close = 0;
#  };
#};

}
