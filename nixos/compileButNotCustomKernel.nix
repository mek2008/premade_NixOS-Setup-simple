{ config, lib, pkgs, ... }:

{
  boot.kernelPatches = [
    {
      name = "custom-hardening-gaming";
      patch = null;
#      ignoreConfigErrors = true; #only use when testing

      structuredExtraConfig = with lib.kernel; {

#        INIT_STACK_ALL_PATTERN = yes;
        INIT_ON_ALLOC_DEFAULT_ON = yes;
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

