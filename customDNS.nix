{ config, lib, pkgs, ... } :
{

services.unbound = {
  enable = true;
  settings = {
    server = {
      interface = [ "127.0.0.1" ];
      access-control = [ "127.0.0.0/8 allow" ];

      # Hardening parameters matching your custom kernel logic
      harden-glue = true;
      harden-dnssec-stripped = true;
      use-caps-for-id = true; # Anti-spoofing capitalization randomization
      edns-buffer-size = 1232;
      prefetch = true;
      num-threads = 4; # Adjust based on your 12-core CPU

      # Privacy flags
      hide-identity = true;
      hide-version = true;
      qname-minimisation = true; # Only sends minimum info required to each zone
    };
  };
};

# Force systemd-resolved to use your local Unbound server
services.resolved = {
  enable = true;
  settings.Resolve = {
    DNS = "127.0.0.1";
    DNSOverTLS = "no"; # Not needed since queries stay local on your loopback
    DNSSEC = "yes";
    Domains = [ "~." ];
  };
};
}
