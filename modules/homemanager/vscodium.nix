{ config, pkgs, ... }:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
    mutableExtensionsDir = false;
    profiles.default = {

      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions =
        with pkgs.vscode-extensions;
        [
          bbenoist.nix
          gruntfuggly.todo-tree
          redhat.vscode-yaml
          eamodio.gitlens
          devsense.composer-php-vscode
          devsense.phptools-vscode
          arcticicestudio.nord-visual-studio-code
          naumovs.color-highlight
          vscode-icons-team.vscode-icons
          rust-lang.rust-analyzer
          ms-azuretools.vscode-docker
          #TODO not present  budparr.language-hugo-vscode
          bmewburn.vscode-intelephense-client
          # REPLACED bungcip.better-toml
          tamasfe.even-better-toml
          ms-vscode-remote.remote-ssh
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "latte";
            publisher = "kasik96";
            version = "0.18.0";
            sha256 = "gxnjUUtkeTlbASCoBMbyGuVEtTvp027Gx5+ngHwEms0=";
          }
          {
            name = "intelli-php-vscode";
            publisher = "devsense";
            version = "0.12.14619";
            sha256 = "Jt7khNc6vZK5yaOMIpqqHfKyrhno2YsOgqxVgKms31I=";
          }
        ];
      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "diffEditor.renderSideBySide" = false;
        "editor.columnSelection" = false;
        "editor.copyWithSyntaxHighlighting" = false;
        "editor.detectIndentation" = false;
        "editor.emptySelectionClipboard" = false;
        "editor.fontFamily" = "FiraCode Nerd Font";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = false;
        "editor.formatOnType" = true;
        # "editor.gotoLocation.multipleDeclarations" = "goto";
        # "editor.gotoLocation.multipleDefinitions" = "goto";
        # "editor.gotoLocation.multipleImplementations" = "goto";
        # "editor.gotoLocation.multipleReferences" = "goto";
        # "editor.gotoLocation.multipleTypeDefinitions" = "goto";
        "editor.insertSpaces" = true;
        "editor.largeFileOptimizations" = false;
        "editor.lineNumbers" = "relative";
        "editor.minimap.enabled" = false;
        "editor.multiCursorModifier" = "ctrlCmd";
        "editor.renderControlCharacters" = true;
        "editor.renderLineHighlight" = "none";
        "editor.renderWhitespace" = "boundary";
        "editor.snippetSuggestions" = "top";
        "editor.suggestFontSize" = 16;
        "editor.tabSize" = 4;
        "editor.wordWrapColumn" = 240;
        "emmet.includeLanguages" = {
          "latte" = "html";
        };
        "explorer.confirmDragAndDrop" = false;
        "extensions.supportUntrustedWorkspaces" = { };
        "files.autoGuessEncoding" = true;
        "files.insertFinalNewline" = true;
        "files.exclude" = {
          "**/.git" = false;
        };
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "git.confirmSync" = false;
        "git.decorations.enabled" = false;
        "git.enableCommitSigning" = true;
        "git.ignoreLimitWarning" = true;
        # "git.ignoredRepositories" = [
        #     "/home/charles"
        # ];
        "gitlens.blame.ignoreWhitespace" = true;
        "gitlens.codeLens.enabled" = false;
        "gitlens.hovers.currentLine.over" = "line";
        "gitlens.statusBar.enabled" = false;
        "html.format.contentUnformatted" = "pre;code;textarea";
        "html.format.extraLiners" = "head; body; /html";
        "html.format.indentHandlebars" = false;
        "html.format.indentInnerHtml" = false;
        "html.format.maxPreserveNewLines" = null;
        "html.format.preserveNewLines" = true;
        "html.format.wrapAttributes" = "preserve-aligned";
        "html.format.wrapLineLength" = 240;
        "[markdown]" = {
          "editor.quickSuggestions" = {
            "comments" = "on";
            "strings" = "on";
            "other" = "on";
          };
        };
        # "[php]" = {
        #     "editor.formatOnSave" = true;
        #     "editor.defaultFormatter" = "junstyle.php-cs-fixer";
        # };
        "php.suggest.basic" = false;
        "redhat.telemetry.enabled" = false;
        "rest-client.decodeEscapedUnicodeCharacters" = true;
        "scm.diffDecorations" = "all";
        "search.useIgnoreFiles" = false;
        "search.exclude" = {
          "**/vendor/" = true;
          "**/public/" = true;
          "**/node_modules" = true;
          "**/dist" = true;
          "**/composer.lock" = true;
          "**/package-lock.json" = true;
          "storage" = true;
          ".phpunit.result.cache" = true;
        };
        # "sqltools.connections" = [
        #     {
        #         "askForPassword" = false;
        #         "connectionTimeout" = 30;
        #         "database" = "mysql";
        #         "driver" = "MySQL";
        #         "name" = "localhost";
        #         "password" = "6xU5ow7cuJxucvU";
        #         "port" = 3306;
        #         "server" = "127.0.0.1";
        #         "username" = "root";
        #     }
        # ];
        "terminal.integrated.defaultProfile.linux" = "bash";
        "terminal.integrated.fontSize" = 12;
        "terminal.integrated.profiles.linux" = {
          "Host = Bash (new pty)" = {
            "path" = "/usr/bin/flatpak-spawn";
            "args" = [
              "--env=TERM=vscode"
              "--host"
              "script"
              "--quiet"
              "/dev/null"
            ];
          };
          "JavaScript Debug Terminal" = null;
          "sh" = null;
          "sh (2)" = null;
        };
        "todo-tree.general.tags" = [
          "BUG"
          "HACK"
          "FIXME"
          "TODO"
          "XXX"
          "[ ]"
          "[x]"
        ];
        "todo-tree.highlights.enabled" = true;
        "todo-tree.highlights.defaultHighlight" = {
          "icon" = "alert";
          "type" = "text";
          "foreground" = "red";
          "background" = "white";
          "opacity" = 50;
          "iconColour" = "blue";
        };
        "todo-tree.highlights.customHighlight" = {
          "TODO" = {
            "icon" = "check";
            "type" = "line";
          };
          "FIXME" = {
            "foreground" = "black";
            "iconColour" = "yellow";
            "gutterIcon" = true;
          };
        };
        "todo-tree.tree.showCountsInTree" = true;
        "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^\\s*(-|\\d+.))\\s*($TAGS)";
        "vsicons.dontShowNewVersionMessage" = true;
        "window.newWindowDimensions" = "inherit";
        "workbench.colorTheme" = "Nord";
        "workbench.editor.enablePreviewFromQuickOpen" = false;
        "workbench.editor.showTabs" = "multiple";
        "workbench.iconTheme" = "vscowindowManager.hyprlandde-icons";
        "workbench.statusBar.visible" = false;
        "workbench.sideBar.location" = "right";
        "workbench.tips.enabled" = false;
        "workbench.startupEditor" = "newUntitledFile";
        "yaml.customTags" = [
          "!encrypted/pkcs1-oaep scalar"
          "!vault scalar"
        ];
        "workbench.editor.enablePreview" = false;
        "git.autofetch" = true;
        "workbench.editor.empty.hint" = "hidden";
        "explorer.confirmDelete" = false;
        "window.zoomLevel" = 1;
        "security.workspace.trust.untrustedFiles" = "open";
      };
      keybindings = [
        {
          "key" = "ctrl+r";
          "command" = "workbench.action.terminal.runRecentCommand";
          "when" = "terminalFocus";
        }
        # Panels
        {
          "key" = "ctrl+k ctrl+e";
          "command" = "workbench.view.explorer";
        }
        {
          "key" = "ctrl+k ctrl+g";
          "command" = "workbench.view.scm";
        }
        {
          "key" = "ctrl+k ctrl+d";
          "command" = "workbench.view.debug";
        }
        {
          "key" = "ctrl+k ctrl+x";
          "command" = "workbench.extensions.action.showInstalledExtensions";
        }
        {
          "key" = "ctrl+k ctrl+b";
          "command" = "workbench.action.toggleSidebarVisibility";
        }
        {
          "key" = "ctrl+e";
          "command" = "workbench.action.focusActiveEditorGroup";
        }
        {
          "key" = "ctrl+t";
          "command" = "workbench.action.terminal.toggleTerminal";
        }
        # File Explorer
        {
          "key" = "ctrl+d";
          "command" = "duplicate.execute";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !inputFocus";
        }
        {
          "key" = "ctrl+n";
          "command" = "explorer.newFile";
          "when" = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
        }
        {
          "key" = "shift+ctrl+n";
          "command" = "explorer.newFolder";
          "when" = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
        }
        # Line Manipulation
        {
          "key" = "ctrl+l";
          "command" = "editor.action.copyLinesDownAction";
          "when" = "editorTextFocus";
        }
        {
          "key" = "ctrl+j";
          "command" = "editor.action.joinLines";
          "when" = "editorTextFocus";
        }
        {
          "key" = "shift+ctrl+[";
          "command" = "editor.fold";
          "when" = "editorFocus";
        }
        {
          "key" = "shift+ctrl+]";
          "command" = "editor.unfold";
          "when" = "editorFocus";
        }
        # Multi-Cursor
        {
          "key" = "ctrl+backspace";
          "command" = "editor.action.moveSelectionToPreviousFindMatch";
          "when" = "editorFocus && editorHasMultipleSelections";
        }
        {
          "key" = "ctrl+k ctrl+d";
          "command" = "editor.action.moveSelectionToNextFindMatch";
          "when" = "editorFocus && editorHasMultipleSelections";
        }
        {
          "key" = "ctrl+right";
          "command" = "editor.action.insertCursorAtEndOfEachLineSelected";
          "when" = "editorFocus && editorHasSelection";
        }
        # Split Panels
        {
          "key" = "alt+w";
          "command" = "workbench.action.joinAllGroups";
          "when" = "editorFocus";
        }
        {
          "key" = "alt+n";
          "command" = "workbench.action.splitEditor";
          "when" = "editorFocus";
        }
        {
          "key" = "alt+l";
          "command" = "workbench.action.navigateRight";
          "when" = "editorFocus";
        }
        {
          "key" = "alt+h";
          "command" = "workbench.action.navigateLeft";
          "when" = "editorFocus";
        }
        {
          "key" = "alt+=";
          "command" = "workbench.action.increaseViewSize";
          "when" = "editorFocus";
        }
        {
          "key" = "alt+-";
          "command" = "workbench.action.decreaseViewSize";
          "when" = "editorFocus";
        }
        # IntelliSense
        {
          "key" = "ctrl+r";
          "command" = "workbench.action.gotoSymbol";
        }
        {
          "key" = "ctrl+shift+r";
          "command" = "workbench.action.showAllSymbols";
        }
        {
          "key" = "ctrl+k ctrl+enter";
          "command" = "editor.action.goToDeclaration";
          "when" = "editorTextFocus";
        }
        {
          "key" = "ctrl+k ctrl+i";
          "command" = "namespaceResolver.import";
        }
      ];
    };
  }; # END of programs.vscode
}
