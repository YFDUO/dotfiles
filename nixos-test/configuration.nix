{ config, pkgs, ... }:

{
  # bootloader and disks with btrfs
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Точки монтирования
  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/sda3";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/sda3";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  # net
  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.fish.enable = true;

  # user
  users.users.aptivace = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;  # Fish как дефолтная оболочка
    initialPassword = "123";
  };

  # sudo
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "PASSWD" ]; } ];
    }
  ];

  # login manager - LY
  services.displayManager.ly.enable = true;

  # hypr
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal desktop
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # OpenGL for some laptops
  hardware.graphics.enable = true;

  # polkit
  security.polkit.enable = true;

  # for thunar needs
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # env
  environment.variables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
  };

  # system packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # system utils
    git
    vim
    wget
    curl
    htop
    fastfetch
    unzip
    gzip
    udiskie


    # pipewire
    pipewire
    wireplumber
    pulsemixer
  ];

  # sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  #  jack.enable = true; # if u need
  };
  security.rtkit.enable = true;

  # flakes settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  hardware.enableRedistributableFirmware = true;

  # timezone
  time.timeZone = "Asia/Yekaterinburg";

  # system version settings
  system.stateVersion = "26.05";
}
