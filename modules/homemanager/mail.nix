# mbsync https://beb.ninja/post/email/
# msmtp https://nixos.wiki/wiki/Msmtp
# https://sbr.pm/configurations/mails.html
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      neomutt
      isync
      mailcap
      msmtp
      notmuch-mutt
      urlscan
      khard
      vcal
      vdirsyncer
      w3m
      libsForQt5.pim-sieve-editor
    ];
  };
  #FIXME dynamic user / home-manager.users.charles.accounts.contact.basePath
  #TODO programs.khard.settings accounts.contact.accounts..khard.enable
  xdg.configFile."khard/khard.conf".text = # toml
    ''
      [addressbooks]
      [[contacts]]
      path = ~/.local/share/contacts/contacts/
    '';
  #FIXME dynamic user, sops, UID
  #TODO https://github.com/pimutils/vdirsyncer/issues/1021 after it's fixed create script until
  #TODO vdirsyncer discover nextcloud_contacts needs confirmation
  #TODO accounts.contact.accounts..vdirsyncer.enable & services.vdirsyncer.
  xdg.configFile."vdirsyncer/config".text = # ini
    ''
      [general]
      status_path = "~/.config/vdirsyncer/status/"
      [pair nextcloud_contacts]
      a = "nextcloud_contacts_local"
      b = "nextcloud_contacts_remote"
      collections = ["from a", "from b"]
      metadata = ["displayname"]
      [storage nextcloud_contacts_local]
      type = "filesystem"
      path = "~/.local/share/contacts/"
      fileext = ".vcf"
      [storage nextcloud_contacts_remote]
      type = "carddav"
      url = "https://cloud.ochman.info/remote.php/dav/addressbooks/users/charles/"
      username.fetch = ["shell", "source /run/user/1111/secrets/charles/nextcloud ; echo $USERNAME"]
      password.fetch = ["shell", "source /run/user/1111/secrets/charles/nextcloud ; echo $PASSWORD"]
    '';
  # username.fetch = ["shell", "${pkgs.gnused}/bin/sed", "-n", "'/^USERNAME=/s///p'", "/run/user/1111/secrets/charles/nextcloud"]

  xdg.configFile."neomutt/mailcap".text =
    ''
      # HTML
      text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
      text/plain; ${pkgs.nano}/bin/nano %s
      text/calendar; ${pkgs.vcal}/bin/vcal %s; copiousoutput;

      #PDFs
      application/pdf; ${pkgs.okular}/bin/okular %s pdf

      #Images
      image/png; ${pkgs.imv}/bin/imv %s
      image/jpeg; ${pkgs.imv}/bin/imv %s
    '';

  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/5";
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

  services.mbsync = {
    enable = true;
    configFile = "${config.xdg.configHome}/isync/mbsyncrc"; # FIXME it's read but not written to
    postExec = "${pkgs.notmuch}/bin/notmuch new";
    verbose = false;
  };
  programs.mbsync.enable = true;
  programs.msmtp = {
    enable = true; # FIXME `.config/msmtp/msmtp` contains extra "account default: karelkremel"
  };
  programs.notmuch = {
    # TODO config https://notmuchmail.org/mutttips/
    enable = true;
  };

  programs.neomutt = {
    changeFolderWhenSourcingAccount = true;
    enable = true;
    unmailboxes = true;
    sidebar = {
      enable = true;
      format = "%D%?F? [%F]?%* %?N?%N/?%S";
      shortPath = true;
      width = 30;
    };
    editor = "nano -r 80 -S %s";
    checkStatsInterval = 10;
    extraConfig =
      let
        # Collect all addresses and aliases
        addresses = lib.flatten (
          lib.mapAttrsToList (n: v: [ v.address ] ++ v.aliases) config.accounts.email.accounts
        );
      in
      # hdr_order = "From List-Id Organization Reply-To To CC Bcc Date Subject";
      # ignore = "*";
      # unignore = "From Subject To Cc Bcc Reply-To Organization Date List-Id";
      # unhdr_order = "*";
      ''
        alternates "${lib.concatStringsSep "|" addresses}"
        alternative_order application/pgp-encrypted text/plain text/enriched text/html text/* text/calendar
        auto_view text/html text/calendar application/ics application/pgp-encrypted
        set mime_type_query_command = "${pkgs.file}/bin/file --mime-type -b %s"
        set pager_context = 3
        set pager_index_lines = 10

        # Default index colors:
        color index default default '.*'
        color index_author default default '.*'
        color index_number color2 default
        color index_subject default default '.*'

        # New mail is boldened:
        color index_author color3 default "~N"
        color index_subject color3 default "~N"
        color index brightyellow black "~N"

        color progress black cyan



        # Tagged mail is highlighted:
        color index_author default color5 "~T"
        color index_subject default color5 "~T"

        color sidebar_new color3 default


        color signature         red                 default

        mono bold bold
        mono underline underline
        mono indicator reverse
        mono error bold

        # Base
        color hdrdefault  color07  color00
        color header      color07  color00  "^"
        # Strong
        color header      color07  color00  "^(From)"
        # Highlight
        color header      color07  color00  "^(Subject)"

        # Regex highlighting:
        color header color4 default "^From"
        color header color5 default "^Subject"
        color header color4 default "^(CC|BCC)"
        color header color4 default ".*"



        color body brightred default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+" # Email addresses
        color body brightblue default "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+" # URL
        color body green default "\`[^\`]*\`" # Green text between ` and `
        color body brightblue default "^# \.*" # Headings as bold blue
        color body brightcyan default "^## \.*" # Subheadings as bold cyan
        color body brightgreen default "^### \.*" # Subsubheadings as bold green
        color body yellow default "^(\t| )*(-|\\*) \.*" # List items as yellow
        color body brightcyan default "[;:][-o][)/(|]" # emoticons
        color body brightcyan default "[;:][)(|]" # emoticons
        color body brightcyan default "[ ][*][^*]*[*][ ]?" # more emoticon?
        color body brightcyan default "[ ]?[*][^*]*[*][ ]" # more emoticon?
        color body red default "(BAD signature)"
        color body cyan default "(Good signature)"
        color body brightblack default "^gpg: Good signature .*"
        color body brightyellow default "^gpg: "
        color body brightyellow red "^gpg: BAD signature from.*"
        color body red default "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"


        # color body color3 default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+" 	# Email addresses
        # color body color3 default "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+" 	# URL
        # color body color7 default "\`[^\`]*\`" 					# Green text between ` and `
        # color body color2 default "^# \.*" 					# Headings as bold blue
        # color body color2 default "^## \.*" 				# Subheadings as bold cyan
        # color body color2 default "^### \.*" 				# Subsubheadings as bold green
        # color body color5 default "^(\t| )*(-|\\*) \.*" 			# List items as yellow
        # color body color1 default "(BAD signature)"
        # color body color2 default "(Good signature)"
        # color body color2 default "^gpg: Good signature .*"
        # color body color2 default "^gpg: "
        # color body color1 default "^gpg: BAD signature from.*"
        mono body bold "^gpg: Good signature"
        mono body bold "^gpg: BAD signature from.*"
      '';
    binds = [
      {
        action = "noop";
        key = "\\Cf"; # notmuch
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "noop";
        key = "\\Cu"; # urlscan
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "noop";
        key = "i"; # changing mailbox
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "noop";
        key = "M"; # move to
        map = [
          "index"
          "pager"
        ];
      }

      {
        action = "sidebar-toggle-visible";
        key = "B";
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "group-reply";
        key = "R";
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "sidebar-prev";
        key = "<S-Up>";
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "sidebar-open";
        key = "<S-Right>";
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "sidebar-next";
        key = "<S-Down>";
        map = [
          "index"
          "pager"
        ];
      }
      {
        action = "sync-mailbox";
        key = "<tab>";
        map = [ "index" ];
      }
      {
        action = "noop";
        key = "<space>";
        map = [ "editor" ];
      }

      {
        action = "collapse-thread";
        key = "<space>";
        map = [ "index" ];
      }

    ];
    macros =
      let
        browserpipe = "cat /dev/stdin > /tmp/muttmail.html && ${pkgs.xdg-utils}/bin/xdg-open /tmp/muttmail.html";
      in
      [
        {
          action = "<enter-command>set my_old_pipe_decode=$pipe_decode my_old_wait_key=$wait_key nopipe_decode nowait_key<enter><shell-escape>notmuch-mutt -r --prompt search<enter><change-folder-readonly>`echo $HOME/.cache/notmuch/mutt/results`<enter><enter-command>set pipe_decode=$my_old_pipe_decode wait_key=$my_old_wait_key<enter>i";
          key = "\\Cf";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<pipe-message>${pkgs.urlscan}/bin/urlscan<enter><exit>";
          key = "\\Cu";
          map = [
            "pager"
            "index"
          ];
        }

        {
          action = "<pipe-message>${pkgs.khard}/bin/khard add-email<return>";
          key = "A";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<shell-escape>${pkgs.isync}/bin/mbsync -c ${config.xdg.configHome}/isync/mbsyncrc -a<enter>";
          key = "O";
          map = [ "index" ];
        }
        {
          action = "<sync-mailbox><enter-command>unmailboxes *<enter><enter-command>source /home/charles/.config/neomutt/karelkremel@gmail.com<enter><change-folder>!<enter>";
          key = "i2";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<sync-mailbox><enter-command>unmailboxes *<enter><enter-command>source /home/charles/.config/neomutt/karelkremel@karelkremel.com<enter><change-folder>!<enter>";
          key = "i3";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<sync-mailbox><enter-command>unmailboxes *<enter><enter-command>source /home/charles/.config/neomutt/charles@alembiq.net<enter><change-folder>!<enter>";
          key = "i4";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<sync-mailbox><enter-command>unmailboxes *<enter><enter-command>source /home/charles/.config/neomutt/karel@ochman.info<enter><change-folder>!<enter>";
          key = "i5";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<sync-mailbox><enter-command>unmailboxes *<enter><enter-command>source /home/charles/.config/neomutt/karel.kremel@snempohanskychobci.org<enter><change-folder>!<enter>";
          key = "i6";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<pipe-entry>${browserpipe}<enter><exit>";
          key = "V";
          map = [ "attach" ];
        }
        {
          action = "<pipe-message>${pkgs.urlscan}/bin/urlscan<enter><exit>";
          key = "F";
          map = [ "pager" ];
        }
        {
          action = "<view-attachments><search>html<enter><pipe-entry>${browserpipe}<enter><exit>";
          key = "V";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "<save-message>=ACCESS<enter>";
          key = "Ma";
          map = [
            "index"
            "pager"
            "browser"
          ];
        }
        {
          action = "<save-message>=MONEY<enter>";
          key = "Mm";
          map = [
            "index"
            "pager"
            "browser"
          ];
        }
        {
          action = "<save-message>=WORK<enter>";
          key = "Mw";
          map = [
            "index"
            "pager"
            "browser"
          ];
        }
      ];
    settings = {
      allow_ansi = "yes";
      askcc = "yes";
      autoedit = "yes";
      collapse_unread = "no";
      crypt_use_gpgme = "yes";
      crypt_autosign = "yes";
      crypt_opportunistic_encrypt = "yes";
      crypt_replyencrypt = "yes";
      crypt_replysign = "yes";
      crypt_replysignencrypted = "yes";
      crypt_timestamp = "yes";
      crypt_verify_sig = "yes";
      date_format = ''"%d/%m/%y %H:%M"'';
      display_filter = ''"tac | sed '/\\\[-- Autoview/,+1d' | tac"'';
      empty_subject = ''"Re: your untitled mail"'';
      fast_reply = "yes";
      fcc_attach = "yes";
      forward_attachments = "yes";
      forward_format = ''"Fwd: %s"'';
      forward_quote = "yes";
      help = "no";
      charset = "utf-8";
      imap_check_subscribed = "yes";
      implicit_autoview = "yes";
      include = "yes";
      mailcap_path = "~/.config/neomutt/mailcap";
      mail_check = "1";
      mail_check_stats = "yes";
      mark_old = "no";
      markers = "no";
      mime_forward = "yes";
      pager_stop = "yes";
      # set pgp_clearsign_command="gpg --no-verbose --batch --output - --passphrase-fd 0 --armor --textmode --clearsign %?a?-u %a? %f"
      # set pgp_decode_command="gpg %?p?--passphrase-fd 0? --no-verbose --batch --output - %f"
      # set pgp_decrypt_command="gpg --passphrase-fd 0 --no-verbose --batch --output - %f"
      # set pgp_encrypt_only_command="pgpewrap gpg --batch --quiet --no-verbose --output - --encrypt --textmode --armor --always-trust --encrypt-to 0x5B7883F4 -- --hidden-recipient %r -- %f"
      # set pgp_encrypt_sign_command="pgpewrap gpg --passphrase-fd 0 --batch --quiet --no-verbose --textmode --output - --encrypt --sign %?a?-u %a? --armor --always-trust --encrypt-to 0x5B7883F4 -- --hidden-recipient %r -- %f"
      # set pgp_export_command="gpg --no-verbose --export --armor %r"
      # set pgp_import_command="gpg --no-verbose --import -v %f"
      # set pgp_list_pubring_command="gpg --no-verbose --batch --with-colons --list-keys %r"
      # set pgp_list_secring_command="gpg --no-verbose --batch --with-colons --list-secret-keys %r"
      # set pgp_sign_command="gpg --no-verbose --batch --output - --passphrase-fd 0 --ar
      pgp_strict_enc = "yes";
      query_command = ''"${pkgs.khard}/bin/khard email --parsable --search-in-source-files '%s'"'';
      reverse_alias = "yes";
      reverse_name = "yes";
      rfc2047_parameters = "yes";
      sidebar_divider_char = "│";
      # sidebar_folder_indent = "yes";
      sidebar_new_mail_only = "no";
      sidebar_non_empty_mailbox_only = "no";
      sidebar_on_right = "yes";
      sidebar_sort_method = "unsorted";
      sig_dashes = "no";
      sig_on_top = "yes";
      sleep_time = "1";
      smart_wrap = "yes";
      smtp_authenticators = "gssapi:login";
      sort = "threads sort_aux=last-date";
      sort_browser = "reverse-date";
      status_format = ''"%f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?d? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?]---(%s/%S)-%>-(%P)---"'';
      status_on_top = "yes";
      strict_threads = "yes";
      text_flowed = "yes";
      uncollapse_jump = "yes";
      uncollapse_new = "yes";
      wait_key = "no";
      wrap = "120";
    };
  };

}
