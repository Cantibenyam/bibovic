{ config, pkgs, ... }:

let
  wallpaper = ./wp/koishi.jpg;

  palette = {
    bg      = "#0f111a";
    bg_rgba = "rgba(15,17,26,55)"; # Deepest blue-black (Background)
    bg_alt  = "#1a1d29";   # Slightly lighter (Panels/Bars)
    fg      = "#a9b1d6";  
    fg_rgba = "rgba(169, 177, 214, 00)"; # Pale grey-blue (Text)
    accent  = "#7aa2f7";   # The glowing blue eye color (Active borders/Highlights)
    accent2 = "#7dcfff";   # A lighter cyan for gradients
    muted   = "#565f89";   # Dimmed text/comments
    red     = "#f7768e";   # Errors/Danger
    green   = "#9ece6a";   # Success
  };

  c = hex: builtins.substring 1 6 hex;



in
{
  home.username = "nyam";
  home.homeDirectory = "/home/nyam";
  home.stateVersion = "24.05"; 

  home.packages = with pkgs; [
    kitty
    waybar
    swww
    rofi
    dunst
    libnotify
    helix
    hyprpaper
    wireplumber
    zathura
    playerctl
    docker
    nerd-fonts.jetbrains-mono
    btop];
  
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
  

  programs.eza = {
      enable = true;
      enableBashIntegration = true;
      icons = "auto";
      git = true;
    };
  
  programs.bat = {
    enable = true;
    config = {
        theme = "Dracula";
      };
    };

#=============================================ALIASES==========================================================================================================================================
  programs.bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = {
        ls = "eza --icons=always --group-directories-first";
        ll = "eza -al --icons=always --group-directories-first";
        cat = "bat";
        edit = "nvim ~/dotfiles";
        update = "cd ~/dotfiles && git add . && sudo nixos-rebuild switch --flake . && cd ~";
        split = "hyprctl dispatch workspace 9 & kitty --class rice-left & kitty --class rice-right &";

      };
  };
 #===================================================================================================================================================================================================   


  programs.yazi = {
  enable = true;
  enableZshIntegration = true;
  enableBashIntegration = true;
  settings = {
    manager = {
      show_hidden = false;
      sort_by = "alphabetical";
      sort_dir_first = true;
      linemode = "none";
    };
  };
};


  programs.zathura = {
    enable = true;
    options = {
    recolor = true;
    recolor-lightcolor = "${palette.bg_rgba}";
    recolor-darkcolor = "${palette.fg}";
    default-bg = "${palette.bg_rgba}"; 
    statusbar-bg = "${palette.bg_alt}";
    statusbar-fg = "${palette.fg}";
    adjust-open = "best-fit";
    guioptions = "none";
  };

    mappings = {
      i = "recolor";
      j = "feedkeys \"<C-Down>\"";
      k = "feedkeys \"<C-Up>\"";
    };
  };
  

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    extraConfig = ''
      # --- RICE LAYOUT RULES (Forced via extraConfig) ---
      
      # LEFT
      windowrulev2 = float,initialClass:^(rice-left)$
      windowrulev2 = size 20% 90%,initialClass:^(rice-left)$
      windowrulev2 = move 1% 5%,initialClass:^(rice-left)$
      windowrulev2 = opacity 0.8,initialClass:^(rice-left)$

      # RIGHT
      windowrulev2 = float,class:^(rice-right)$
      windowrulev2 = size 20% 90%,class:^(rice-right)$
      windowrulev2 = move 79% 5%,class:^(rice-right)$
      windowrulev2 = opacity 0.8,class:^(rice-right)$
    '';


    settings = {


      monitor = ", 2560x1440@144, auto, 1";
      exec-once = [
        "hyprlock"
        "waybar"

      ];
      windowrulev2 = [
      "opacity 0.80 0.80 override,class:^(org.pwmt.zathura)$"];  
      general = {
        gaps_in = 4;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(${c palette.accent}) rgb(${c palette.accent2}) 45deg";
        "col.inactive_border" = "rgb(${c palette.bg_alt})";
        layout = "master";

        resize_on_border = true;
        extend_border_grab_area = 15;
      };

      master = {
        mfact = 0.6;
        orientation = "left";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(000000ee)";
          };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

#===================================================================BINDS========================================================================================================================
      "$mainMod" = "SUPER";
      
      binde = [
        ", F2, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ", F3, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ];

      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, rofi -show drun"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, RETURN, layoutmsg, swapwithmaster"
        ", Print, exec, grimblast copy area"
        "ALT, Tab, cyclenext"
        "ALT SHIFT, Tab, cyclenext, prev"
      ] ++ (
        builtins.concatLists (builtins.genList (
            i: let 
              ws = i + 1;
            in [
              "$mainMod, code:1${toString i}, workspace, ${toString ws}"
              "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    };
  };
#================================================================================================================================================================================================
      
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      
      preload = [
        "${wallpaper}"
      ];

      wallpaper = [
        {
        monitor = "eDP-1";
        path = "${wallpaper}";
        fit_mode = "cover";
        }
      ];
    };
  };

  programs.home-manager.enable = true;
  programs.gemini-cli.enable = true; 
  programs.gemini-cli.defaultModel = "gemini-2.5-pro";
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "nyam";
        email = "your-email@example.com";
      };
    };
  };
  
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
        hide_cursor = true;
        ignore_empty_input = true;
        screencopy_mode = 0;
        fail_timeout = 0;
      };
      
      animations = {
          enabled = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.3;
        }
      ];
      
      label = [
      {
        text = "$TIME";
        font_size = 95;
        position = "0, 300";
        color = "${palette.fg}";
      }
      ];

      input-field = [
        {
          size = "250, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          hide_input = true;
          font_color = "rgb(${c palette.fg})";
          inner_color = "rgb(${c palette.bg})";
          outer_color = "rgb(${c palette.accent})";
          outline_thickness = 2;
          placeholder_text = "<i>...enter the void...</i>";
          shadow_passes = 2;
          rounding = 10;
        }
      ];


    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.5";
      confirm_os_window_close = 0;
      window_padding_width = 15;
      cursor_shape = "beam";
      cursor_blink_interval = 0.5;
    };

    theme = "Catppuccin-Mocha";
  };

  programs.starship = 
{
  enable = true;
  enableBashIntegration = true; # Let's ensure this is ON
  
  settings = {
    add_newline = true;
    
    # This sets the format for the whole prompt
    format = ''
      [](#04050A )$os$username[](bg: fg:#110F18)$directory[](fg:#060D17 bg:#252B3A)$git_branch$git_status[](fg:#181F2E bg:#333C4E)$c$elixir$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala[](fg:#576678 bg:#A6B5C3)$docker_context[](fg:#C2C9B5) $character
    '';
    # 1. The OS Icon
    os = {
      disabled = false;
      style = "bg:#04050A";
    };
    os.symbols = {
      NixOS = " "; # The NixOS snowflake
    };

    # 2. The Username
    username = {
      show_always = true;
      style_user = "bg:#04050A";
      style_root = "bg:#04050A";
      format = "[$user ]($style)";
    };
    # 3. The Directory
    directory = {
      style = "bg:#110F18";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    # 4. Git Information
    git_branch = {
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    git_status = {
      style = "bg:#252B3A";
      format = "[[($all_status$ahead_behind )](fg:#282828 bg:#252B3A)]($style)";
    };   
    # 5. Language Icons (Add more as needed)
    nodejs = {
      symbol = "";
      style = "bg:#86BBD8";
      format = "[[ $symbol ($version) ](fg:#282828 bg:#86BBD8)]($style)";
    };
    rust = {
      symbol = "";
      style = "bg:#86BBD8";
      format = "[[ $symbol ($version) ](fg:#282828 bg:#86BBD8)]($style)";
    };
    
    # 6. The Character (The arrow at the end)
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol = "[✗](bold red)";
    };
  };
};


  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        
        # MARGINS: Top/Left/Right gaps for that "floating" look
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ 
          "group/music"   # <--- The expandable music module
          "pulseaudio" 
          "network" 
          "battery" 
          "tray" 
        ];

        # -------------------------------------------------------------------------
        # MODULE CONFIGURATION
        # -------------------------------------------------------------------------
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            urgent = "";
            focused = "";
            default = "";
          };
        };
        
        "clock" = {
          # format = "{:%H:%M}  ";
          format = "{:%I:%M %p} ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        # --- EXPANDABLE MUSIC GROUP ---
        "group/music" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 500;
            children-class = "not-power";
            transition-left-to-right = false;
          };
          modules = [
            "custom/music-icon" # The icon always visible
            "mpris"             # The player controls (hidden until hovered)
          ];
        };

        "custom/music-icon" = {
          format = " ";
          tooltip = false;
        };

        "mpris" = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {
            paused = "⏸";
          };
          # ignored-players = ["firefox"]; # Optional: ignore browser audio
        };
        
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        "network" = {
          format-wifi = " ";
          format-ethernet = "";
          format-disconnected = " ";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
      };
    };

    # -------------------------------------------------------------------------
    # CSS STYLING (Injecting the 'palette' variables)
    # -------------------------------------------------------------------------
   style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left, .modules-center, .modules-right {
        background: ${palette.bg_alt};
        border: 1px solid ${palette.fg};
        border-radius: 10px;
        padding-left: 10px;
        padding-right: 10px;
      }

      #workspaces button {
        padding: 0 5px;
        color: ${palette.muted};
      }

      #workspaces button.active {
        color: ${palette.accent};
      }

      #workspaces button.urgent {
        color: ${palette.red};
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
        padding: 0 10px;
        color: ${palette.fg};
      }

      #custom-music-icon {
        color: ${palette.accent};
        padding-right: 10px;
      }
      
      #mpris {
        color: ${palette.fg};
        padding: 0 10px;
        background: ${palette.bg};
        border-radius: 15px;
        margin: 3px 0;
      }

      #battery.charging, #battery.plugged {
        color: ${palette.green};
      }

      @keyframes blink {
        to {
          background-color: ${palette.red};
          color: ${palette.bg};
        }
      }

      #battery.critical:not(.charging) {
        color: ${palette.red};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';  };
 }
