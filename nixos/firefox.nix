{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
 
    # Policies apply to the entire browser application
    policies = {
      ExtensionSettings = {
        # Default policy
        "*" = {
          installation_mode = "allowed";
        };

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };

        # ClearURLs
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "force_installed";
        };

        # Cyber Rain Theme
        "{febe2d2f-66fe-4772-9fcc-3fc20cdb0cfb}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/animated-cyber-rain/latest.xpi";
#          installation_mode = "force_installed";
        };
      }; # Fixed missing brace for ExtensionSettings
    };

    # Profile-specific configurations
    profiles.mk = {
      settings = {
        # Required for userChrome.css (set to true if you use it)
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Enhanced Tracking Protection = Strict
        "browser.contentblocking.category" = "strict";

        # Tell websites not to sell/share my data (Global Privacy Control)
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.functionality.enabled" = true;

        # Also send Do Not Track
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;

        # DNS over HTTPS (Mullvad)
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";

        # HTTPS Only Mode
        "dom.security.https_only_mode" = true;

        # Disable telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.ping-centre.telemetry" = false;

        # Disable Pocket
        "extensions.pocket.enabled" = false;

        # Disable sponsored suggestions
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        
        # DNS prefetch off
        "network.dns.disablePrefetch" = true;

        # Speculative connections off
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;

        # Resist fingerprinting (optional)
        # "privacy.resistFingerprinting" = true;
        
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1; # Compact mode
      };
  bookmarks = {
    force = true;
    settings = [
          {
        name = "Proton Mail";
        url = "https://mail.proton.me/";
          }
          {
        name = "GitHub";
        url = "https://github.com/";
          }
          {
        name = "YouTube";
        url = "https://www.youtube.com/";
          }
          {
        name = "Proton Apps";
        url = "https://account.proton.me/apps";
          }
        ];
      };

    };
  };
}

