{ config, pkgs, ... }:
{
  # 1. Enable Ollama with the CUDA package variant
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  # 2. Hard block telemetry and restrict systemd execution privileges
  systemd.services.ollama = {
    environment = {
      OLLAMA_DEBUG = "0";
      OLLAMA_HOST = "127.0.0.1:11434";
    };

    serviceConfig = {
      IPAddressDeny = [ "any" ];
      IPAddressAllow = [ "127.0.0.1/32" "::1/128" ];

      ProtectHome = true;
      ProtectSystem = "strict";
      PrivateTmp = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
    };
  };

  # 3. Enable Open WebUI
  services.open-webui = {
    enable = true;
    port = 8080;

    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      WEBUI_AUTH = "True";
    };
  };

  systemd.services.open-webui.serviceConfig = {
    IPAddressDeny = [ "any" ];
    IPAddressAllow = [ "127.0.0.1/32" "::1/128" ];
    ProtectHome = true;
    ProtectSystem = "strict";
  };
}
