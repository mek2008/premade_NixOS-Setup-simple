{ config, pkgs, ... }:

let
  wallpaper = ./wallpapers/wallthree.png;
in
{
  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${wallpaper}
    '')
  ];
}
