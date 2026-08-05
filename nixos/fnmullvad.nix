{ config, pkgs, ... }:

{
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn; # includes GUI; use pkgs.mullvad if you only want the CLI daemon
  };

  environment.etc."mullvad-vpn/settings.json" = {
    text = builtins.toJSON {
      allow_lan = true; # critical for you — lets you reach n8n/Mistral on your LAN while tunneled
      auto_connect = true; # connects on boot/login, matches your "always-on" preference
      block_when_disconnected = true; # kill-switch: no traffic leaks out if the tunnel drops
      settings_version = 10;
    };
    mode = "0600";
  };
}
