{ config, pkgs, ... }:

let
  # Define the wallpaper path here so Nix handles the absolute path.
  # Ensure your file is named 'images.jpg' inside the 'wp' folder!
  wallpaper = ./wp/eientei_large.jpg; 
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
  ];
  
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
   
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    settings = {
      # Monitor Setup (Was missing)
      monitor = ", 2560x1440@144, auto, 1";

      # --- Appearance ---
      general = {
        gaps_in = 2;
        gaps_out = 6;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "master";
      };

      master = {
        mfact = 0.7;
        orientation = "left";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
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
    extraConfig = {
      user = {
        name = "nyam";
        email = "your-email@example.com";
      };
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.2"; # 0.3 is very hard to see!
      confirm_os_window_close = 0;
    };
  };
}
