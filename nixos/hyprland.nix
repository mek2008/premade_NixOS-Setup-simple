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
XDG_SESSION_TYPE = "wayland";
GDK_BACKEND = "wayland,x11,*";
WLR_DRM_NO_ATOMIC = "1";
WLR_FORCE_LIBINPUT = "1";
QT_QPA_PLATFORM = "wayland;xcb";
SDAM_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
QT_SCALE_FACTOR = "1";
WLR_DPI = "96";
};


xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];

}


