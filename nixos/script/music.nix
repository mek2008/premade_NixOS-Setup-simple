{ config, lib, pkgs, ... }:
{
  options.mySystem.music.enable = lib.mkEnableOption "music terminal tool";

  config = lib.mkIf config.mySystem.music.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "music" ''
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --unshare-all \
          --die-with-parent \
          --ro-bind /nix /nix \
          --ro-bind /etc/resolv.conf /etc/resolv.conf \
          --dev /dev \
          --proc /proc \
          --tmpfs /tmp \
          --share-net \
          ${pkgs.mpv}/bin/mpv "$(${pkgs.yt-dlp}/bin/yt-dlp -f ba -g "$1")"
      '')
    ];
  };
}
