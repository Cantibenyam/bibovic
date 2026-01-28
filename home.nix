{ config, pkgs, ... }:

let
  # Define the wallpaper path here so Nix handles the absolute path.
  # Ensure your file is named 'images.jpg' inside the 'wp' folder!
  wallpaper = ./wp/koishi.jpg; 
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
];
  
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


  programs.bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = {
        ls = "eza --icons=always --group-directories-first";
        ll = "eza -al --icons=always --group-directories-first";
        cat = "bat";
        edit = "nvim ~/dotfiles";
        update = "cd ~/dotfiles && git add . && sudo nixos-rebuild switch --flake . && cd ~";

      };
  };
    


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
  
  #ZATHURA  
  programs.zathura = {
    enable = true;
    options = {
    #alpha = "0.8";
    # Transparency specific settings
    recolor = true;
    recolor-lightcolor = "rgba(30,30,46,0.3)";
    recolor-darkcolor = "#cdd6f4";
    default-bg = "rgba(30,30,46, 0.3)"; 
    # UI and Behavior
    statusbar-bg = "rgba(30,30,46,0.3)";
    statusbar-fg = "#cdd6f4";
    adjust-open = "best-fit";
    guioptions = "none";
  };

  # Translate 'map key command' to key = "command"
  mappings = {
    i = "recolor";
    
    # Smooth scrolling maps (note the escaped quotes for the command)
    j = "feedkeys \"<C-Down>\"";
    k = "feedkeys \"<C-Up>\"";
  };
  };
  #stylix.enable = true;
  #stylix.image = "${wallpaper}";
  #stylix.targets.zathura.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

     settings = {
      monitor = ", 2560x1440@144, auto, 1";
      exec-once = [
        "hyprlock"
      ];

     windowrulev2 = [
      "opacity 0.80 0.80 override,class:^(org.pwmt.zathura)$"
    ];  


      general = {
        gaps_in = 2;
        gaps_out = 6;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "master";
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
          passes = 2;
          new_optimizations = true;
        };
        shadow = {

          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(f2dfd199)";
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
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<i>...your secret...</i>";
          shadow_passes = 2;
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

  programs.starship = {
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
 }
