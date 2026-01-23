{ config, pkgs, ... }:

{
  # Replace 'your-username'
  home.username = "nyam";
  home.homeDirectory = "/home/nyam";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "23.11"; 

  # Packages to install for this user (The Ricing Starter Pack)
  home.packages = with pkgs; [
    kitty        # Terminal
    waybar       # The top bar
    swww         # Wallpaper daemon
    rofi-wayland # App launcher
    libnotify    # Notification library
    dunst        # Notification daemon
    networkmanagerapplet # Wi-fi tray icon
  ];

  # Enable Home Manager and Git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Imangali Duisebayev";
    userEmail = "nyamthenyam@gmail.com";
  };
}
