{ config, lib, pkgs, ... }:
{
  boot.kernelPatches = [
    {
      name = "custom-hardening-gaming";
      patch = null;

      extraStructuredConfig = with lib.kernel; {

        # ============ CONFIRMED SAFE — KSPP baseline hardening ============
        INIT_STACK_ALL_ZERO = yes; # zero-init stack vars, kills uninitialized-read bugs
        INIT_ON_ALLOC_DEFAULT_ON = yes; # zero heap on alloc
        INIT_ON_FREE_DEFAULT_ON = yes; # zero heap on free (also blunts UAF info leaks)
        SLAB_FREELIST_HARDENED = yes; # freelist metadata sanity checks
        SLAB_FREELIST_RANDOM = yes; # randomize freelist order
        SHUFFLE_PAGE_ALLOCATOR = yes; # randomize page allocator freelists
        FORTIFY_SOURCE = yes; # compile-time buffer overflow checks
        HARDENED_USERCOPY = yes; # bounds-check copy_to/from_user
        HARDENED_USERCOPY_FALLBACK = no; # hard-fail instead of warn-and-continue
        REFCOUNT_FULL = yes; # overflow-checked refcounting
        SECURITY = yes;
        SECURITY_YAMA = yes; # ptrace_scope restrictions
        DEBUG_WX = yes; # warn on W+X kernel mappings
        BUG_ON_DATA_CORRUPTION = yes; # panic instead of limping on corruption
        STACKPROTECTOR_STRONG = yes;
        VMAP_STACK = yes; # guard-paged kernel stacks, catches overflow
        PAGE_TABLE_ISOLATION = yes; # Meltdown mitigation (KPTI)
        RETPOLINE = yes; # Spectre v2 mitigation
        RANDOMIZE_BASE = yes; # KASLR
        RANDOMIZE_MEMORY = yes; # physical memory layout randomization
        LEGACY_VSYSCALL_NONE = yes; # kill legacy vsyscall page, common ROP target
        STRICT_DEVMEM = yes; # restrict /dev/mem
        IO_STRICT_DEVMEM = yes;
        SYN_COOKIES = yes;
        RANDOMIZE_KSTACK_OFFSET_DEFAULT = yes;
#        SECURITY_LOCKDOWN_LSM = yes; # enables lockdown framework (mode set via kernelParams below) but no signed kernel
#        SECURITY_LOCKDOWN_LSM_EARLY = yes;  # no signed kernel

        # BPF: restrict unprivileged use, keep BPF itself (a lot of tooling
        # assumes it exists — outright removing BPF_SYSCALL is the more
        # brutal option, left in the "maybe" section below)
        BPF_UNPRIV_DEFAULT_OFF = yes;

        # ============ MAYBE ZONE — real tradeoffs, read before uncommenting ============

        # Full structure-layout randomization via GCC plugin. nixpkgs' stdenv
        # gcc is NOT built with -fplugin support by default, so this is a
        # no-op / build failure unless you override pkgs.stdenv.cc.cc with
        # `enableGCCPlugins = true` — expensive full gcc rebuild, only worth
        # it if RANDSTRUCT is a hard requirement for you.
        # GCC_PLUGIN_RANDSTRUCT = yes;
        # RANDSTRUCT_FULL = yes;

        # Kernel Control Flow Integrity — real hardening value against
        # ROP/JOP, but currently has real compatibility friction with
        # out-of-tree Nvidia modules on some kernel/driver version combos.
        # Try it, and if Nvidia refuses to load, disable this first before
        # anything else.
        # CFI_CLANG = yes; # requires building the kernel with clang, not gcc — bigger change than it looks

        # Fully removes unprivileged BPF instead of just restricting default.
        # Breaks some perf-tooling/sandboxing software (some anti-cheat and
        # profilers use BPF). Test before committing.
        # BPF_SYSCALL = no;

        # Stackleak: erases kernel stack contents after each syscall to stop
        # stack content leaks across syscalls. Has a measurable (~1-5%)
        # perf cost on syscall-heavy workloads — noticeable in some games.
        # GCC_PLUGIN_STACKLEAK = yes; # also needs GCC plugin support, see RANDSTRUCT note above

        # Latent entropy plugin: also needs GCC plugin support. Marginal
        # value, same build-cost problem as RANDSTRUCT/STACKLEAK.
        # GCC_PLUGIN_LATENT_ENTROPY = yes;

        # Module signing WITHOUT lockdown enforcement — lets you inspect
        # signature status without breaking anything. Real enforcement
        # lives in the separate lanzaboote block below, not here.
        # MODULE_SIG = yes;
        # MODULE_SIG_ALL = yes;

        # ============ HARDWARE / GAMING OPTIMIZATION ============
        HZ_1000 = yes; # 1000Hz tick, lower input latency
        HZ = freeform "1000";
        PREEMPT_DYNAMIC = yes;
        PREEMPT = no; # full kernel preemption
        PREEMPT_VOLUNTARY = no;
        SCHED_AUTOGROUP = no; # throughput-smoothing heuristic that adds jitter under gaming load

        # AMD Ryzen 7535HS specific
        MICROCODE_AMD = yes;
        X86_AMD_PSTATE = yes; # native AMD P-State frequency scaling, better than acpi-cpufreq on Zen
        AMDGPU_SI = no; # pre-GCN AMD chips, not your hardware — trim
        AMDGPU_CIK = no; # ditto

        # Transparent hugepages: real throughput win for gaming workloads,
        # small latency-spike risk under memory pressure with only 16GB RAM.
        TRANSPARENT_HUGEPAGE_ALWAYS = no;
        TRANSPARENT_HUGEPAGE_MADVISE = yes;

# Legacy/unaudited filesystems — nothing but ext4/vfat/fat loadedREISERFS_FS = no;
JFS_FS = no;
XFS_FS = no;
HFS_FS = no;
HFSPLUS_FS = no;
UFS_FS = no;
MINIX_FS = no;
NILFS2_FS = no;
SYSV_FS = no;

# Amateur radio protocols — not applicable to your hardware/use case
AX25 = no;
NETROM = no;
ROSE = no;

# Legacy ports — no floppy/parallel port on this laptop
PARPORT = no;
FLOPPY = no;

# Wifi vendor drivers not in use — MediaTek only, no fallback dongle kept
ATH9K = no;
ATH10K = no;
ATH10K_PCI = no;
ATH10K_USB = no;
IWLWIFI = no;
RTL8XXXU = no;
RTW88 = no;
RTW89 = no;

# USB video class — no webcam use
USB_VIDEO_CLASS = no;


      };
    }
  ];

  # Lockdown mode is a kernelParam, not a config bit — "integrity" blocks
  # /dev/mem and unsigned module loading but still allows Nvidia if it's
  # unsigned-but-in-tree-adjacent; "confidentiality" is stricter and WILL
  # block your unsigned Nvidia module outright. Stick with integrity, or
  # omit lockdown= entirely if you want zero friction with Nvidia for now.

  environment.systemPackages = [ pkgs.kernel-hardening-checker ];
}
