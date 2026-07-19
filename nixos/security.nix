{ config, lib, pkgs, ... } :
{


boot.kernel.sysctl = {
  "kernel.kptr_restrict" = 2;
  "kernel.dmesg_restrict" = 1;
  "kernel.yama.ptrace_scope" = 2;
  "kernel.unprivileged_bpf_disabled" = 1;
  "net.core.bpf_jit_harden" = 2;
  "kernel.kexec_load_disabled" = 1;
  "kernel.sysrq" = 0;

  "net.ipv4.conf.all.rp_filter" = 1;
  "net.ipv4.conf.default.rp_filter" = 1;
  "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  "net.ipv4.conf.all.accept_source_route" = 0;
  "net.ipv6.conf.all.accept_source_route" = 0;
  "net.ipv4.conf.all.accept_redirects" = 0;
  "net.ipv6.conf.all.accept_redirects" = 0;
  "net.ipv4.conf.all.send_redirects" = 0;
  "net.ipv4.tcp_syncookies" = 1;

  "net.ipv4.tcp_rfc1337" = 1;
  "net.ipv4.conf.all.log_martians" = 1;
  "net.ipv4.conf.default.log_martians" = 1;
};



systemd.coredump.enable = false;

#boot.loader.systemd-boot.enable = lib.mkForce false;

services.resolved = {
  enable = true;
  settings.Resolve = {
    DNS = "194.242.2.2#dns.mullvad.net";
    FallbackDNS = "194.242.2.3#dns.mullvad.net";
    DNSOverTLS = "yes";
    DNSSEC = "yes";
    Domains = [ "~." ]; # <-- add this, replaces the old top-level `domains = [ "~." ];`
  };
};

networking.wireless.iwd = {
  enable = true;
  settings = {
    General = {
      AddressRandomization = "network"; # per-network MAC, not just per-boot
      AddressRandomizationRange = "full";
    };
    Network = {
      EnableIPv6 = true; # keep true only if IPv6 firewall rules mirror IPv4 (see below)
    };
    Settings = {
      AutoConnect = true;
    };
  };
};




  # apply per-service, not globally:
  #
  # systemd.services."your-service".serviceConfig = {
  # ProtectSystem = "strict";
  # ProtectHome = true;
  # PrivateTmp = true;
  # NoNewPrivileges = true;
  # ProtectKernelTunables = true;
  # ProtectKernelModules = true;
  # ProtectControlGroups = true;
  # RestrictNamespaces = true;
  # };



}
