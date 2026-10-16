{ config, lib, pkgs, ... }:

{
  boot.kernelPatches = [
    {
      name = "custom-hardening-gaming";
      patch = null;
#      ignoreConfigErrors = true; #only use when testing

      structuredExtraConfig = with lib.kernel; {

        #############################################################
        ## KSPP hardening
        #############################################################

        CC_OPTIMIZE_FOR_PERFORMANCE = yes;

#        LTO_CLANG_THIN = yes;  #experimental

        INIT_STACK_ALL_ZERO = yes;   #slower than pattern
#        INIT_STACK_ALL_PATTERN = yes;
        INIT_ON_ALLOC_DEFAULT_ON = yes;
        INIT_ON_FREE_DEFAULT_ON = yes;

        SLAB_FREELIST_HARDENED = yes;
        SLAB_FREELIST_RANDOM = yes;
        SHUFFLE_PAGE_ALLOCATOR = yes;
        SLAB_MERGE_DEFAULT = no;

        FORTIFY_SOURCE = yes;
        HARDENED_USERCOPY = yes;

        SECURITY = yes;
        SECURITY_YAMA = yes;
        SECURITY_SAFESETID = yes;
        SECURITY_LANDLOCK = yes;

        SECCOMP = yes;
        SECCOMP_FILTER = yes;

        AUDIT = yes;
        AUDITSYSCALL = yes;

        DEBUG_WX = yes;
        BUG_ON_DATA_CORRUPTION = yes;

        STACKPROTECTOR_STRONG = yes;
        VMAP_STACK = yes;
#        STACKLEAK = yes;
#        STACKLEAK_RUNTIME_DISABLE = yes;

        RANDOMIZE_BASE = yes;
        RANDOMIZE_MEMORY = yes;
        RANDOMIZE_KSTACK_OFFSET_DEFAULT = yes;
        RANDOM_KMALLOC_CACHES = yes; # experimental

       
#        MODULE_COMPRESS_ZSTD = yes; #test
        MODULE_SIG = lib.mkForce yes;
        MODULE_SIG_SHA512 = yes;

        LEGACY_VSYSCALL_NONE = yes;

        STRICT_DEVMEM = yes;
        IO_STRICT_DEVMEM = yes;

        SYN_COOKIES = yes;

        BPF_UNPRIV_DEFAULT_OFF = yes;

        #############################################################
        ## Removed from newer kernels (keep for future reference)
        #############################################################

        # Removed in newer kernels.
        # HARDENED_USERCOPY_FALLBACK = no;

        # Removed / integrated.
        # REFCOUNT_FULL = yes;

        # Automatic on supported hardware.
        # PAGE_TABLE_ISOLATION = yes;

        # Compiler mitigation now automatic.
        # RETPOLINE = yes;

        # Microcode handled elsewhere.
        # MICROCODE_AMD = yes;
           
          #MODULE_SIG_FORCE = yes;


        #############################################################
        ## Scheduler
        #############################################################

        HZ_1000 = yes;
        HZ = freeform "1000";

#        PREEMPT_DYNAMIC = yes;
#        PREEMPT = lib.mkForce no;
#        PREEMPT_VOLUNTARY = lib.mkForce no;

        X86_MSR = yes;
        CPU_FREQ = yes;
        CPU_FREQ_STAT = yes;

        SCHED_AUTOGROUP = lib.mkForce no;

        #############################################################
        ## AMD
        #############################################################

        X86_AMD_PSTATE = yes;
        PROCESSOR_SELECT = yes;
#        MZEN3 = yes;

#        AMDGPU_SI = lib.mkForce no;
#        AMDGPU_CIK = lib.mkForce no;

        #############################################################
        ## Transparent Huge Pages
        #############################################################

        TRANSPARENT_HUGEPAGE_ALWAYS = lib.mkForce no;
        TRANSPARENT_HUGEPAGE_MADVISE = yes;

        #############################################################
        ## Disable unused filesystems
        #############################################################

#        REISERFS_FS = lib.mkForce no;
        JFS_FS = lib.mkForce no;
#        XFS_FS = lib.mkForce no;
        HFS_FS = lib.mkForce no;
        HFSPLUS_FS = lib.mkForce no;
        UFS_FS = lib.mkForce no;
        MINIX_FS = lib.mkForce no;
        NILFS2_FS = lib.mkForce no;

        # Removed in Linux 6.18+
        # SYSV_FS = no;

        #############################################################
        ## Amateur radio
        #############################################################

        AX25 = lib.mkForce no;

        # Hidden once AX25 is disabled.
 #       IPX = lib.mkForce no;
 #       ATALK = lib.mkForce no;
 #       DECNET = lib.mkForce no;
 #       LLC = lib.mkForce no;
 #       TOKEN_RING = lib.mkForce no;
 #       NETROM = lib.mkForce no;
 #       ROSE = lib.mkForce no;



        #############################################################
        ## Legacy hardware
        #############################################################

        PARPORT = lib.mkForce no;

        # Removed in newer kernels.
        # FLOPPY = no;

        #############################################################
        ## Wi-Fi drivers you don't use
        #############################################################

        ATH9K = lib.mkForce no;
        ATH10K = lib.mkForce no;
 #       ATH10K_PCI = lib.mkForce no;
 #       ATH10K_USB = lib.mkForce no;

        IWLWIFI = lib.mkForce no;

        RTL8XXXU = lib.mkForce no;

#        RTW88 = lib.mkForce no;
        RTW89 = lib.mkForce no;

        # Removed automatically when RTW88 is disabled.
        # RTW88_8822BE = no;
        # RTW88_8822CE = no;

        #############################################################
        ## Camera
        #############################################################

        USB_VIDEO_CLASS = lib.mkForce no;
      };
    }
  ];



  nix.settings = {
    max-jobs = "auto";
    cores = 12;
  };

  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
#    gcc.arch = "znver3";
  };

#systemd.package = pkgs.systemd.overrideAttrs (old: {
#   NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -march=znver3 -mtune=znver3";
#});

  environment.systemPackages = [
    pkgs.kernel-hardening-checker
  ];



#!!!warning: compiles everything!!!
#nixpkgs.config.replaceStdenv = ({ pkgs }:
#  pkgs.stdenvAdapters.overrideCFlags [
#    "-march=znver3"
#    "-mtune=znver3"
#  ]
#);


}

