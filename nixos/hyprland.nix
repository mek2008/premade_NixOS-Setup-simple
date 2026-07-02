{ config, pkgs, ... }:
{

programs.hyprland = {
enable = true;
xwayland.enable = true; # Ensures legacy X11 apps scale and run inside Wayland
withUWSM = true;
};

# Hint Electron apps (VS Code, Discord, Chromium) to use Wayland natively
environment.sessionVariables = {
NIXOS_OZONE_WL = "1";
MOZ_ENABLE_WAYLAND = "1";
};


xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];

}


