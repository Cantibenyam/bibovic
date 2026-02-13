{ config, pkgs, ... }:

let
  wallpaper = ./wp/koishi.jpg;

  palette = {
    bg      = "#0f111a";
    bg_rgba = "rgba(15,17,26,00)"; # Deepest blue-black (Background)
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
    eww
    libnotify
    helix
    hyprpaper
    wireplumber
    zathura
    playerctl
    docker
    nerd-fonts.jetbrains-mono
    btop
    imagemagick
    cava
    neofetch
    tty-clock
    pipes
    fortune
    lm_sensors
    nvtopPackages.nvidia];
  
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

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps";
      display-run = "   Run";
      display-window = " 﩯  Window";
    };
  };

  home.file.".config/rofi/theme.rasi".text = ''
    * {
      bg: ${palette.bg_alt};
      bg-alt: ${palette.bg};
      fg: ${palette.fg};
      accent: ${palette.accent};
      accent2: ${palette.accent2};

      background-color: transparent;
      text-color: @fg;
      font: "JetBrainsMono Nerd Font 12";
    }

    window {
      transparency: "real";
      background-color: @bg;
      border: 2px solid;
      border-color: @accent;
      border-radius: 15px;
      width: 600px;
      padding: 20px;
    }

    mainbox {
      children: [inputbar, listview];
      spacing: 15px;
    }

    inputbar {
      background-color: @bg-alt;
      border: 2px solid @accent;
      border-radius: 10px;
      padding: 10px;
      children: [prompt, entry];
    }

    prompt {
      text-color: @accent;
      padding: 0 10px 0 0;
    }

    entry {
      placeholder: "Search...";
      placeholder-color: @fg;
    }

    listview {
      lines: 8;
      scrollbar: false;
    }

    element {
      padding: 10px;
      border-radius: 8px;
    }

    element selected {
      background-color: @accent;
      text-color: @bg;
    }

    element-icon {
      size: 24px;
      margin: 0 10px 0 0;
    }
  '';

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 350;
        offset = "10x45";
        origin = "top-right";
        padding = 20;
        horizontal_padding = 20;
        frame_width = 3;
        corner_radius = 12;
        font = "JetBrainsMono Nerd Font 11";
        format = "<b>「%s」</b>\\n%b";
        icon_position = "left";
        max_icon_size = 64;
        show_indicators = false;
        separator_color = "frame";
        separator_height = 2;
      };

      urgency_low = {
        background = "${palette.bg_alt}";
        foreground = "${palette.fg}";
        frame_color = "${palette.muted}";
        timeout = 5;
        format = "<b>Sign「%s」</b>\\n%b";
      };

      urgency_normal = {
        background = "${palette.bg_alt}";
        foreground = "${palette.fg}";
        frame_color = "${palette.accent}";
        timeout = 8;
        format = "<b>★ Spell Card「%s」</b>\\n%b";
      };

      urgency_critical = {
        background = "${palette.bg_alt}";
        foreground = "${palette.red}";
        frame_color = "${palette.red}";
        timeout = 0;
        format = "<b>♦ Last Word「%s」</b>\\n%b";
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

      # --- WORKSPACE 1 DASHBOARD (Option C Layout) ---
      # Neofetch (top-left, smaller)
      windowrulev2 = workspace 1,class:^(neofetch-rice)$
      windowrulev2 = opacity 0.85,class:^(neofetch-rice)$

      # btop (top-right, larger)
      windowrulev2 = workspace 1,class:^(btop-rice)$
      windowrulev2 = opacity 0.9,class:^(btop-rice)$

      # CAVA (bottom-left)
      windowrulev2 = workspace 1,class:^(cava-rice)$
      windowrulev2 = opacity 0.85,class:^(cava-rice)$

      # System Stats (bottom-right)
      windowrulev2 = workspace 1,class:^(stats-rice)$
      windowrulev2 = opacity 0.9,class:^(stats-rice)$

      # --- WORKSPACE 2 INFO DASHBOARD ---
      # tty-clock
      windowrulev2 = workspace 2,class:^(clock-rice)$
      windowrulev2 = opacity 0.9,class:^(clock-rice)$

      # Weather
      windowrulev2 = workspace 2,class:^(weather-rice)$
      windowrulev2 = opacity 0.9,class:^(weather-rice)$

      # Fortune
      windowrulev2 = workspace 2,class:^(fortune-rice)$
      windowrulev2 = opacity 0.9,class:^(fortune-rice)$

      # Journal
      windowrulev2 = workspace 2,class:^(journal-rice)$
      windowrulev2 = opacity 0.9,class:^(journal-rice)$

      # Git Status
      windowrulev2 = workspace 2,class:^(git-rice)$
      windowrulev2 = opacity 0.9,class:^(git-rice)$
    '';


    settings = {


      # Monitor configuration - all at max resolution and refresh rate
      monitor = [
        "DP-1, 1920x1080@60, 0x0, 1"             # UGD monitor (left)
        "eDP-1, 2560x1600@240, 1920x0, 1"        # Laptop display (middle)
        "HDMI-A-3, 2560x1440@144, 4480x0, 1"     # Samsung Odyssey G5 (right)
      ];

      exec-once = [
        "hyprlock"
        "waybar"
        "eww daemon"
        "~/.config/scripts/startup-rice.sh"
        # Audio verification: test default sink
        "notify-send '🔊 Audio Status' \"Default sink: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)\""
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
          size = 6;
          passes = 2;
          new_optimizations = true;
          vibrancy = 0.2;
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
        # Audio volume controls with visual feedback
        ", F2, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%- && notify-send '🔊 Volume' \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)\"%\"}')\" -t 1000"
        ", F3, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send '🔊 Volume' \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)\"%\"}')\" -t 1000"
      ];

      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreen,"
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

        # Media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        "$mainMod, F10, exec, playerctl play-pause"
        "$mainMod, F11, exec, playerctl previous"
        "$mainMod, F12, exec, playerctl next"
        "$mainMod SHIFT, M, exec, ~/.config/eww/scripts/toggle-media-dashboard.sh"

        # Audio device verification and testing
        "$mainMod SHIFT, A, exec, notify-send '🔊 Audio Test' 'Playing test sound...' && wpctl set-volume @DEFAULT_AUDIO_SINK@ 50% && speaker-test -t sine -f 1000 -l 1 & sleep 0.3 && pkill speaker-test"
        "$mainMod CTRL, A, exec, notify-send '🎵 Audio Devices' \"$(wpctl status | grep -A 5 'Audio' | head -n 10)\" -t 5000"
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

      # Shared wallpaper across all 3 monitors
      wallpaper = [
        "eDP-1, ${wallpaper}"      # Laptop display
        "DP-1, ${wallpaper}"        # UGD monitor
        "HDMI-A-3, ${wallpaper}"    # Samsung Odyssey G5
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
          size = "320, 50";
          position = "0, -120";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          hide_input = false;
          dots_size = 0.3;
          dots_spacing = 0.4;
          font_color = "rgb(${c palette.accent2})";
          inner_color = "rgba(15, 17, 26, 0.6)";
          outer_color = "rgb(${c palette.accent})";
          check_color = "rgb(${c palette.accent2})";
          fail_color = "rgb(${c palette.red})";
          outline_thickness = 4;
          placeholder_text = "";
          shadow_passes = 4;
          rounding = 25;
          capslock_color = "rgb(${c palette.accent2})";
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
          "custom/music"
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

        # --- MUSIC MODULE (clicks to toggle EWW dashboard) ---
        "custom/music" = {
          format = " {}";
          exec = "playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null || echo 'No media'";
          exec-if = "playerctl status 2>/dev/null";
          interval = 2;
          on-click = "~/.config/eww/scripts/toggle-media-dashboard.sh";
          max-length = 40;
          tooltip = true;
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
        background: rgba(26, 29, 41, 0.6);
        border: 1px solid rgba(169, 177, 214, 0.3);
        border-radius: 10px;
        padding-left: 10px;
        padding-right: 10px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      }

      #workspaces button {
        padding: 0 5px;
        color: ${palette.muted};
        transition: all 0.3s ease;
      }

      #workspaces button.active {
        color: ${palette.accent};
        text-shadow: 0 0 10px ${palette.accent};
      }

      #workspaces button.urgent {
        color: ${palette.red};
        text-shadow: 0 0 10px ${palette.red};
      }

      #workspaces button:hover {
        color: ${palette.accent2};
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

      #custom-music {
        color: ${palette.accent};
        padding: 0 10px;
      }

      #custom-music:hover {
        color: ${palette.accent2};
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

  # ============== EWW MEDIA DASHBOARD ==============
  home.file.".config/eww/eww.yuck".text = ''
    (defwindow media-dashboard
      :monitor 0
      :geometry (geometry
        :x "10px"
        :y "45px"
        :width "400px"
        :height "500px"
        :anchor "top right")
      :stacking "overlay"
      :windowtype "normal"
      (media-widget))

    (deflisten music_status "playerctl --follow status 2>/dev/null || echo 'Stopped'")
    (deflisten music_title "playerctl --follow metadata --format '{{ title }}' 2>/dev/null || echo 'No Title'")
    (deflisten music_artist "playerctl --follow metadata --format '{{ artist }}' 2>/dev/null || echo 'No Artist'")
    (deflisten music_album "playerctl --follow metadata --format '{{ album }}' 2>/dev/null || echo '''")
    (deflisten music_arturl "playerctl --follow metadata --format '{{ mpris:artUrl }}' 2>/dev/null || echo '''")
    (defpoll music_position :interval "1s" :initial-value "0" "playerctl position 2>/dev/null | cut -d. -f1 | grep -E '^[0-9]+$' || echo 0")
    (defpoll music_length :interval "1s" :initial-value "0:00" "playerctl metadata --format '{{ duration(mpris:length) }}' 2>/dev/null | grep -v '^$' || echo '0:00'")
    (defpoll volume :interval "1s" :initial-value "50" "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{if($2) print int($2*100); else print 50}'")
    (defpoll power_level :interval "2s" :initial-value "4.00" "awk '{printf \"%.2f\", $1/100*4}' /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 4.00")
    (defpoll cpu_usage :interval "2s" :initial-value "0" "top -bn1 | grep Cpu | awk '{print int($2)}'")
    (defpoll music_easter_egg :interval "2s" :initial-value "♥ Subconscious Silence ♥" "~/.config/eww/scripts/music-easter-egg.sh")

    (defwidget media-widget []
      (box :class "media-dashboard" :orientation "v" :space-evenly false
        (box :class "album-art-container" :halign "center"
          (image :path {music_arturl != "" ? music_arturl : "/home/nyam/.config/eww/assets/music-note.png"}
                 :image-width 300
                 :image-height 300
                 :class "album-art"))

        (box :class "easter-egg-banner" :halign "center"
          (label :class "easter-egg-text" :text music_easter_egg))

        (box :class "track-info" :orientation "v" :space-evenly false :halign "center"
          (label :class "track-title" :text {music_title} :limit-width 35)
          (label :class "track-artist" :text {music_artist} :limit-width 35)
          (label :class "track-album" :text {music_album} :limit-width 35))

        (box :class "progress-section" :orientation "v" :space-evenly false
          (scale :class "progress-bar"
                 :value {music_position}
                 :max 300
                 :onchange "playerctl position {}")
          (box :class "progress-time" :space-evenly true
            (label :text {music_position} :halign "start")
            (label :text {music_length} :halign "end")))

        (box :class "controls" :halign "center" :spacing 20
          (button :class "control-button" :onclick "playerctl previous" "⏮")
          (button :class "control-button play-pause" :onclick "playerctl play-pause"
            {music_status == "Playing" ? "⏸" : "▶"})
          (button :class "control-button" :onclick "playerctl next" "⏭"))

        (box :class "volume-section" :orientation "v" :space-evenly false
          (label :class "volume-label" :text "Volume: ''${volume}%")
          (scale :class "volume-slider"
                 :value volume
                 :max 100
                 :onchange "wpctl set-volume @DEFAULT_AUDIO_SINK@ {}%"))

        (box :class "touhou-stats" :orientation "h" :space-evenly true :spacing 10
          (box :class "power-display" :orientation "v"
            (label :class "stat-label" :text "⚡ Power")
            (label :class "stat-value" :text "''${power_level} / 4.00"))
          (box :class "spell-display" :orientation "v"
            (label :class "stat-label" :text "★ Graze")
            (label :class "stat-value" :text "''${cpu_usage}%")))))
  '';

  home.file.".config/eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "JetBrainsMono Nerd Font";
    }

    .media-dashboard {
      background-color: rgba(26, 29, 41, 0.75);
      border: 2px solid rgba(122, 162, 247, 0.5);
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
    }

    .album-art-container {
      margin-bottom: 15px;
    }

    .album-art {
      border-radius: 10px;
      background-color: ${palette.bg};
    }

    .easter-egg-banner {
      margin: 10px 0;
      padding: 8px 15px;
      background: linear-gradient(90deg, transparent, rgba(122, 162, 247, 0.2), transparent);
      border-top: 1px solid rgba(122, 162, 247, 0.3);
      border-bottom: 1px solid rgba(122, 162, 247, 0.3);
    }

    .easter-egg-text {
      color: ${palette.accent2};
      font-size: 13px;
      font-weight: bold;
      font-style: italic;
    }

    .track-info {
      margin-bottom: 20px;
    }

    .track-title {
      color: ${palette.fg};
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 5px;
    }

    .track-artist {
      color: ${palette.accent};
      font-size: 16px;
      margin-bottom: 3px;
    }

    .track-album {
      color: ${palette.muted};
      font-size: 14px;
    }

    .progress-section {
      margin-bottom: 20px;
    }

    .progress-bar {
      background-color: rgba(15, 17, 26, 0.5);
      border-radius: 10px;
      min-height: 8px;
    }

    .progress-bar trough {
      background-color: rgba(15, 17, 26, 0.5);
      border-radius: 10px;
      min-height: 8px;
    }

    .progress-bar highlight {
      background: linear-gradient(90deg, ${palette.accent}, ${palette.accent2});
      border-radius: 10px;
    }

    .progress-bar slider {
      background-color: ${palette.accent};
      border-radius: 50%;
      min-width: 16px;
      min-height: 16px;
    }

    .progress-time {
      color: ${palette.muted};
      font-size: 12px;
      margin-top: 5px;
    }

    .controls {
      margin-bottom: 20px;
    }

    .control-button {
      background-color: rgba(15, 17, 26, 0.6);
      border: 2px solid rgba(122, 162, 247, 0.7);
      border-radius: 50%;
      color: ${palette.accent};
      font-size: 24px;
      min-width: 60px;
      min-height: 60px;
      transition: all 0.2s;
    }

    .control-button:hover {
      background-color: rgba(122, 162, 247, 0.8);
      color: ${palette.bg};
    }

    .control-button.play-pause {
      min-width: 70px;
      min-height: 70px;
      font-size: 28px;
      border-width: 3px;
    }

    .volume-section {
      margin-top: 10px;
    }

    .volume-label {
      color: ${palette.fg};
      font-size: 14px;
      margin-bottom: 10px;
    }

    .volume-slider {
      background-color: rgba(15, 17, 26, 0.5);
      border-radius: 10px;
      min-height: 8px;
    }

    .volume-slider trough {
      background-color: rgba(15, 17, 26, 0.5);
      border-radius: 10px;
      min-height: 8px;
    }

    .volume-slider highlight {
      background-color: ${palette.accent};
      border-radius: 10px;
    }

    .volume-slider slider {
      background-color: ${palette.accent2};
      border-radius: 50%;
      min-width: 16px;
      min-height: 16px;
    }

    .touhou-stats {
      margin-top: 15px;
      padding: 15px;
      background-color: rgba(15, 17, 26, 0.4);
      border-radius: 10px;
      border: 1px solid rgba(122, 162, 247, 0.3);
    }

    .power-display, .spell-display {
      padding: 5px 10px;
    }

    .stat-label {
      color: ${palette.accent2};
      font-size: 12px;
      font-weight: bold;
      margin-bottom: 5px;
    }

    .stat-value {
      color: ${palette.fg};
      font-size: 16px;
      font-weight: bold;
    }
  '';

  home.file.".config/eww/scripts/toggle-media-dashboard.sh" = {
    text = ''
      #!/usr/bin/env bash
      if eww active-windows | grep -q "media-dashboard"; then
        eww close media-dashboard
      else
        eww open media-dashboard
      fi
    '';
    executable = true;
  };

  home.file.".config/eww/scripts/music-easter-egg.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Music player easter eggs - Touhou style
      status=$(playerctl status 2>/dev/null)
      title=$(playerctl metadata --format '{{ title }}' 2>/dev/null)

      case "$status" in
        "Playing")
          # Check for Touhou references in title
          if echo "$title" | grep -iq "touhou\|necrofantasia\|bad apple\|un owen\|septette"; then
            echo "♫ Spell Card Active ♫"
          else
            echo "♪ Now Playing ♪"
          fi
          ;;
        "Paused")
          echo "⊗ Rose of May - Closed ⊗"
          ;;
        *)
          echo "♥ Subconscious Silence ♥"
          ;;
      esac
    '';
    executable = true;
  };

  # Create placeholder for music note fallback image (will be generated)
  home.file.".config/eww/assets/.keep".text = "";
 }
