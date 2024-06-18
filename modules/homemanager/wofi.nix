{pkgs, config, ...}:
{
    programs.wofi = {
        enable = true;
        settings = {
            width = 600;
            height = 300;
            location = "center";
            show = "drun";
            prompt = "Search...";
            filter_rate = 100;
            allow_markup = true;
            no_actions = true;
            halign = "fill";
            orientation = "vertical";
            content_halign = "fill";
            insensitive = true;
            allow_images = true;
            image_size = 40;
        };
        style = ''
            * {
                transition: 0.1s;
            }

            window {
                font-family: "Comic Code Ligatures";
                font-size: 16px;
            }

            window {
                margin: 0px;
                border: 2px solid #${config.lib.stylix.colors.base09};
                background-color: #${config.lib.stylix.colors.base00};
                border-radius: 16px;
            }

            #input {
                padding: 4px;
                margin: 20px;
                padding-left: 20px;
                border: none;
                color: #${config.lib.stylix.colors.base02};
                font-weight: bold;
                background: #${config.lib.stylix.colors.base04};
                    outline: none;
                border-radius: 16px;
            }

            #input image {
                color: #${config.lib.stylix.colors.base03};
            }

            #input:focus {
                border: none;
                    outline: none;
            }

            #inner-box {
                margin: 20px;
                margin-top: 0px;
                border: none;
                color: #${config.lib.stylix.colors.base0F};
                border-radius: 16px;
            }

            #inner-box * {
                transition: none;
            }

            #outer-box {
                margin: 0px;
                border: none;
                padding: 0px;
                border-radius: 16px;
            }

            #scroll {
                margin-top: 5px;
                border: none;
                border-radius: 16px;
                margin-bottom: 5px;
            }

            #text:selected {
                color: #${config.lib.stylix.colors.base06};
                font-weight: bold;
            }

            #img {
                margin-right: 20px;
                background: transparent;
            }

            #text {
                margin: 0px;
                border: none;
                padding: 0px;
                background: transparent;
            }

            #entry {
                margin: 0px;
                border: none;
                border-radius: 16px;
                background-color: transparent;
                min-height:32px;
                font-weight: bold;
            }

            #entry:selected {
                outline: none;
                margin: 0px;
                border: none;
                border-radius: 16px;
                background: #${config.lib.stylix.colors.base0A};
            }
        '';
    };

}
