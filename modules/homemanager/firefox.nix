{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-esr;
    policies = {
      ExtensionSettings =
        with builtins;
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        listToAttrs [
          # about:support
          (extension "Sideberry" "{3c078156-979c-498b-8990-85f7987dd929}") # TODO FF 136 vertical tabs
          (extension "art-project" "jid1-2owcJCGUIo2yBA@jetpack")
          (extension "auto-tab-discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}")
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          #   (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
          #   (extension "darkreader" "addon@darkreader.org")
          (extension "grammarly-1" "87677a2c52b84ad3a151a4a72f5bd3c4@jetpack")
          (extension "i-dont-care-about-cookies" "jid1-KKzOGWgsW3Ao4Q@jetpack")
          # (extension "tiled-tab-groups" "{dcdaadfa-21f1-4853-9b34-aad681fff6f3}")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          # (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
        ];
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      # https://mozilla.github.io/policy-templates/#policiesjson-44
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        # Exception = [ "https://enocean-edge.atlassian.net" ];
      };
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = false;
      DisplayBookmarksToolbar = "newtab"; # "always" or "newtab"
      DisplayMenuBar = "default-off"; # "always" "never" "default-on"
      SearchBar = "unified"; # "separate"
    };
    profiles.charles = {
      isDefault = true;
      bookmarks = { };
      settings = {
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "experiments.activeExperiment" = false;
        "experiments.enabled" = false;
        "experiments.supported" = false;
        "network.allow-experiments" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.formfill.enable" = {
          Value = "false";
          Status = "locked";
        };
        "browser.search.suggest.enabled" = {
          Value = "false";
          Status = "locked";
        };
        "browser.search.region" = "CZ";
        "browser.search.isUS" = false;
        "browser.sessionstore.resume_session_once" = true;
        "browser.sessionstore.resume_from_crash" = true;
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.translations.neverTranslateLanguages" = "cs";
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.shell.checkDefaultBrowser" = true;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.uiCustomization.state" =
          ''{"placements":{"widget-overflow-fixed-list":[],"nav-bar": ["back-button", "forward-button", "stop-reload-button", "home-button", "urlbar-container", "downloads-button", "ublock0_raymondhill_net-browser-action", "_testpilot-containers-browser-action", "reset-pbm-toolbar-button", "unified-extensions-button", "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action", "_dcdaadfa-21f1-4853-9b34-aad681fff6f3_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":18,"newElementCount":4}'';
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "";
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        "signon.rememberSignons" = false;
        "services.sync.engine.addresses" = false;
        "services.sync.engine.passwords" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "security.sandbox.content.read_path_whitelist" = "/nix/store/";
      };
    };
  }; # END of programs.firefox
}
