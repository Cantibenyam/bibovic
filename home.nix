{ config, pkgs, ... }:

{
  home.username = "nyam";
  home.homeDirectory = "/home/nyam";

  # Set this to the version you installed, or 23.11/24.05 for now
  home.stateVersion = "24.05"; 

  # The Ricing Starter Pack
  home.packages = with pkgs; [
    kitty
    waybar
    swww
    rofi-wayland
    dunst
    libnotify
  ];

  # Enable Home Manager and Git
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "nyam";
    userEmail = "your-email@example.com"; # Change this later!
  };

  # Let's add a basic Kitty config while we're here
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.8";
      confirm_os_window_close = 0;
    };
  };
}
