{ pkgs, config, ... }:
{
  home-manager.users.charles = {
    accounts.contact.basePath = "~/.local/share/contacts/contacts/";
    accounts.email = {
      # Office365 oauth2 https://github.com/harishkrupo/oauth2ms or https://howto.cs.uchicago.edu/nix:mutt
      # maildirBasePath = "$HOME/Maildir";
      accounts."karelkremel@gmail.com" = {
        neomutt = {
          enable = true;
          extraConfig = ''
            mailboxes /home/charles/Maildir/karelkremel@gmail.com/Inbox /home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Drafts /home/charles/Maildir/karelkremel@gmail.com/ACCESS /home/charles/Maildir/karelkremel@gmail.com/MONEY /home/charles/Maildir/karelkremel@gmail.com/WORK /home/charles/Maildir/karelkremel@gmail.com/Kickstarter /home/charles/Maildir/karelkremel@gmail.com/Larp /home/charles/Maildir/karelkremel@gmail.com/Patreon /home/charles/Maildir/karelkremel@gmail.com/Photography "/home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Sent Mail" /home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Spam /home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Bin
            named-mailboxes @gmail.com +Inbox
            named-mailboxes Junk "+[Gmail]/Spam"
            named-mailboxes Sent "+[Gmail]/Sent\ Mail"
            named-mailboxes Trash "+[Gmail]/Bin"
            set record = "+[Gmail]/Sent\ Mail"
            set postponed = "+[Gmail]/Drafts"
            set trash = "+[Gmail]/Bin"
          '';
            # folder-hook . "set sort=date ; set sort_aux=thread"
        };
        flavor = "gmail.com";
        realName = "Karel Křemel";
        address = "karelkremel@gmail.com";
        userName = "karelkremel@gmail.com";
        gpg = {
          key = "4A72 D7FD 235E 50F9 3F68 01A0 05F6 EFFA BE00 2CB2";
          signByDefault = true;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        primary = false;
        signature = {
          text = ''

            Karel Křemel
            karelkremel@gmail.com

          '';
          showSignature = "append";
        };
        # FIXME dynamic UID, sops passwordCommand = "cat ${config.sops.secrets."charles/email/ochman".path}";
        passwordCommand = "${pkgs.coreutils}/bin/cat /home/charles/.local/gmail";
      };
      accounts."karelkremel@karelkremel.com" = {
        neomutt = {
          enable = true;
          extraConfig = ''
            mailboxes /home/charles/Maildir/karelkremel@karelkremel.com/Inbox /home/charles/Maildir/karelkremel@karelkremel.com/Drafts /home/charles/Maildir/karelkremel@karelkremel.com/ACCESS /home/charles/Maildir/karelkremel@karelkremel.com/MONEY /home/charles/Maildir/karelkremel@karelkremel.com/WORK /home/charles/Maildir/karelkremel@karelkremel.com/Archive /home/charles/Maildir/karelkremel@karelkremel.com/ASATRU-eu /home/charles/Maildir/karelkremel@karelkremel.com/Heathenry /home/charles/Maildir/karelkremel@karelkremel.com/Larp /home/charles/Maildir/karelkremel@karelkremel.com/Photography /home/charles/Maildir/karelkremel@karelkremel.com/Junk /home/charles/Maildir/karelkremel@karelkremel.com/Sent /home/charles/Maildir/karelkremel@karelkremel.com/Trash
            named-mailboxes @karelkremel.com +Inbox
          '';
            # folder-hook . "set sort=date ; set sort_aux=thread"
        };
        realName = "Karel Křemel";
        address = "karelkremel@karelkremel.com";
        userName = "karelkremel@karelkremel.com";
        gpg = {
          key = "4A72 D7FD 235E 50F9 3F68 01A0 05F6 EFFA BE00 2CB2";
          signByDefault = true;
        };
        imap = {
          host = "nextmail.alembiq.net";
          port = 993;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        primary = false;
        signature = {
          text = ''

            Karel Křemel

            +420 777 123 644
            karelkremel@karelkremel.com
            www.karelkremel.com

          '';
          showSignature = "append";
        };
        passwordCommand = "${pkgs.coreutils}/bin/cat /home/charles/.local/karelkremel"; # FIXME dynamic UID, sops
        smtp = {
          host = "nextmail.alembiq.net";
        };
      };
      accounts."charles@alembiq.net" = {
        neomutt = {
          enable = true;
          extraConfig = ''
            mailboxes /home/charles/Maildir/charles@alembiq.net/Inbox /home/charles/Maildir/charles@alembiq.net/Drafts /home/charles/Maildir/charles@alembiq.net/ACCESS /home/charles/Maildir/charles@alembiq.net/MONEY /home/charles/Maildir/charles@alembiq.net/WORK /home/charles/Maildir/charles@alembiq.net/GIT /home/charles/Maildir/charles@alembiq.net/MUD-dev /home/charles/Maildir/charles@alembiq.net/Photography /home/charles/Maildir/charles@alembiq.net/vpsFree /home/charles/Maildir/charles@alembiq.net/Sent /home/charles/Maildir/charles@alembiq.net/Junk /home/charles/Maildir/charles@alembiq.net/Trash
            named-mailboxes @alembiq.net +Inbox
          '';
            # folder-hook . "set sort=date ; set sort_aux=thread"
        };
        realName = "Karel | ALEMBIQ.net";
        address = "charles@alembiq.net";
        userName = "charles@alembiq.net";
        gpg = {
          key = "4A72 D7FD 235E 50F9 3F68 01A0 05F6 EFFA BE00 2CB2";
          signByDefault = true;
        };
        imap = {
          host = "nextmail.alembiq.net";
          port = 993;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        primary = false;
        signature = {
          text = ''

            Karel
            ALEMBIQ.net

            charles@alembiq.net
            +420-777 123 644
            www.alembiq.net

          '';
          showSignature = "append";
        };
        passwordCommand = "${pkgs.coreutils}/bin/cat /home/charles/.local/alembiq"; # FIXME dynamic UID, sops
        smtp = {
          host = "nextmail.alembiq.net";
        };
      };
      accounts."karel@ochman.info" = {
        neomutt = {
          enable = true;
          extraConfig = ''
            mailboxes /home/charles/Maildir/karel@ochman.info/Inbox /home/charles/Maildir/karel@ochman.info/Drafts  /home/charles/Maildir/karel@ochman.info/ACCESS /home/charles/Maildir/karel@ochman.info/MONEY /home/charles/Maildir/karel@ochman.info/MONEY/Strnadova /home/charles/Maildir/karel@ochman.info/WORK /home/charles/Maildir/karel@ochman.info/Goverment /home/charles/Maildir/karel@ochman.info/Sent /home/charles/Maildir/karel@ochman.info/Junk /home/charles/Maildir/karel@ochman.info/Trash
            named-mailboxes @ochman.info +Inbox
          '';
            # folder-hook . "set sort=date ; set sort_aux=thread"
        };
        realName = "Karel Ochman";
        address = "karel@ochman.info";
        userName = "karel@ochman.info";
        gpg = {
          key = "B924 244C A7E6 6DB4 7386 7B7C FE39 AAD9 091A 1CD7";
          signByDefault = false;
        };
        imap = {
          host = "nextmail.alembiq.net";
          port = 993;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        primary = true;
        signature = {
          text = ''

            Karel Ochman
            karel@ochman.info
            +420 777 123 644

          '';
          showSignature = "append";
        };
        passwordCommand = "${pkgs.coreutils}/bin/cat /home/charles/.local/ochman";
        smtp = {
          host = "nextmail.alembiq.net";
        };
      };
      accounts."karel.kremel@snempohanskychobci.org" = {
        neomutt = {
          enable = true;
          extraConfig = ''
            mailboxes /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Inbox /home/charles/Maildir/karel.kremel@snempohanskychobci.org/INBOX@INFO /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Drafts /home/charles/Maildir/karel.kremel@snempohanskychobci.org/ACCESS /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Sent /home/charles/Maildir/karel.kremel@snempohanskychobci.org/SENT@INFO /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Junk /home/charles/Maildir/karel.kremel@snempohanskychobci.org/JUNK@INFO /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Trash
            named-mailboxes @snempohanskychobci.org +Inbox
          '';
            # folder-hook . "set sort=date ; set sort_aux=thread"
        };
        realName = "Karel Křemel | Sněm pohanských obcí";
        address = "karel.kremel@snempohanskychobci.org";
        userName = "karel.kremel@snempohanskychobci.org";
        gpg = {
          key = "4A72D7FD235E50F93F6801A005F6EFFABE002CB2";
          signByDefault = true;
        };
        imap = {
          host = "nextmail.alembiq.net";
          port = 993;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        primary = false;
        signature = {
          text = ''

            Karel Křemel
            karel.kremel@snempohanskychobci.org
            www.snempohanskychobci.org

          '';
          showSignature = "append";
        };
        passwordCommand = "${pkgs.coreutils}/bin/cat /home/charles/.local/snempohanskychobci"; # FIXME dynamic UID, sops
        smtp = {
          host = "nextmail.alembiq.net";
        };
      };
    };
  };

}
