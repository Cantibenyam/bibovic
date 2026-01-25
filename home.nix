{ config, pkgs, ... }:

{
  home.username = "nyam";
  home.homeDirectory = "/home/nyam";
  home.stateVersion = "24.05"; 

  # Force the symlink so Nix stays in control
  xdg.configFile."hypr/hyprland.conf".force = true;

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

  home.file.".config/hypr/wallpaper.jpg".source = ./wp/images.jpg;
  wayland.windowManager.hyprland.settings = {
    exec-once = [
     
    ];
  };
  services.hyprpaper = {
  enable = true;
  settings = {
    ipc = "on";
    splash = true;
    
    # 1. Load the image into memory (REQUIRED)
    preload = [
      "./wp/images.jpg"
    ];

    # 2. Apply the image to monitors
    # Syntax: "monitor, /path/to/image"
    # Leaving the monitor empty (the comma is vital) applies it to ALL monitors
    wallpaper = [
      ",./wp/images.jpg"
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
      background_opacity = "0.3";
      confirm_os_window_close = 0;
    };
  };



  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      
      # --- Appearance ---
      general = {
        gaps_in = 2;
        gaps_out = 6;
        border_size = 2;
        # Simplified color format to avoid syntax errors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "master";
      };
      master = {
        mfact = 0.7;
        orientation = "center";
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
}
