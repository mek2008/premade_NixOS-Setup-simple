{ config, lib, pkgs, ... } :
{

security.rtkit.enable = true;
security.polkit.enable = true;
#security.apparmor.enable = true;
services.opensnitch.enable = true;
security.sudo.execWheelOnly = true;
#programs.firejail.enable = true;

services.logind.settings.Login.KillUserProcesses = true;
security.sudo.enable = false;
security.doas.enable = false;
security.polkit.adminIdentities = [ "unix-user:root" ];

security.audit.enable = true;
security.audit.rules = [
  "-w /etc/passwd -p wa -k passwd_changes"
  "-w /etc/nixos -p wa -k config_changes"
  "-w /etc/shadow -p wa -k shadow_changes"
  "-w /etc/ssh -p wa -k ssh_config_changes"
  "-a always,exit -F arch=b64 -S execve -k exec_tracking"
  "-a always,exit -F arch=b32 -S execve -k exec_tracking"
];

boot.blacklistedKernelModules = [
#  "bluetooth"
#  "btusb"
  "firewire_core"
  "firewire_ohci"
  "dccp"
  "sctp"
  "rds"
  "tipc"
  "f2fs" "btrfs" "jfs" " nilfs2" "ufd"
];


boot.kernelParams = [
    "slab_nomerge"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_alloc.shuffle=1"
    "randomize_kstack_offset=on"
    "audit_backlog_limit=8192"
    "mitigations=auto" # Spectre/Meltdown mitigations, SMT stays on (no nosmt — that's the real FPS tax)
#    "lockdown=integrity"  #no signed GPU driver
    "lru_gen=1"
    "page_poison=1"
    "vsyscall=none"
    "panic=0"
    "debugfs=off"
    "iommu=force"
    "iommu.strict=1"
    "amd_iommu=on"
#    "module.sig_enforce=1"
];


boot.kernel.sysctl = {
  "kernel.kptr_restrict" = 2;
  "kernel.dmesg_restrict" = 1;
  "kernel.yama.ptrace_scope" = 2;
  "kernel.unprivileged_bpf_disabled" = 1;
  "kernel.unprivileged.users_clone" = 0;
  "kernel.io_uring_disabled" = 2;
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

  "fs.protected_fifos" = 2;
  "fs.protected_regular" = 2;
  "fs.protected_hardlinks" = 1;
  "fs.protected_symlinks" = 1;
  "fs.suid_dumpable" = 0;
#  "vm.unprivileged_userfaultfd" = 0;
  "kernel.perf_event_paranoid" = 3;
};




systemd.coredump.enable = false;

fileSystems."/proc" = {
  fsType = "proc";
  device = "proc";
  options = [ "nosuid" "nodev" "noexec" "hidepid=2" ];
};

fileSystems."/tmp" = {
  fsType = "tmpfs";
  device = "tmpfs";
  options = [ "nosuid" "nodev" "noexec" "size=2G" ];
};


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

#networking.wireless.iwd = {
#  enable = true;
#  settings = {
#    General = {
#      AddressRandomization = "network"; # per-network MAC, not just per-boot
#      AddressRandomizationRange = "full";
#    };
#    Network = {
#      EnableIPv6 = true; # keep true only if IPv6 firewall rules mirror IPv4 (see below)
#    };
#    Settings = {
#      AutoConnect = true;
#    };
#  };
#};


networking.networkmanager = {
  enable = true;
  wifi.backend = "wpa_supplicant";
};

services.tor = {
  enable = true;
  client.enable = true;
};

networking.wireless = {
  enableHardening = true;

#  userControlled = {
#    enable = true;
#    group = "wheel";
#  };

allowAuxiliaryImperativeNetworks = true;

  iwd.enable = lib.mkForce false;

  extraConfig = ''
    p2p_disabled=1
    pmf=2
    mac_addr=1
    preassoc_mac_addr=1
    bgscan="simple:600:-72:45"
  '';
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

systemd.services."opensnitch".serviceConfig = { 
   ProtectSystem = "strict";
   ProtectHome = true;
   PrivateTmp = true;
   NoNewPrivileges = true;
   ProtectKernelTunables = true;
   ProtectKernelModules = true;
   ProtectControlGroups = true;
   RestrictNamespaces = true;
};

programs.firejail = {
  enable = true;
  wrappedBinaries = {

#    firefox = {
#      executable = "${lib.getBin pkgs.firefox}/bin/firefox";
#      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
#      extraArgs = [
#        "--apparmor"
#      ];
#    };

    vscodium = {
      executable = "${lib.getBin pkgs.vscodium}/bin/codium";
      profile = "${pkgs.firejail}/etc/firejail/vscodium.profile";
      extraArgs = [
        "--apparmor"
      ];
    };


    librewolf = {
      executable = "${lib.getBin pkgs.librewolf}/bin/librewolf";
      profile = "${pkgs.firejail}/etc/firejail/librewolf.profile";
      extraArgs = [
        "--apparmor"
      ];
    };





  };
};


security.apparmor = {
  enable = true;

  packages = [
    pkgs.apparmor-profiles
  ];

#  policies."usr.bin.firefox" = {
#    profile = "${pkgs.apparmor-profiles}/etc/apparmor.d/usr.bin.firefox";
#    state = "complain";
#  };
};


}
