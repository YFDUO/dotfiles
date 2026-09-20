{ config, pkgs, ... }:

{
  # fish (main shell)
  programs.fish = {
    enable = true;

    # interactive settings
      # remove greeting
    shellInit = ''
      set -g fish_greeting
    '';
      # fish_config theme choose "Dracula" # if u want some theme add this to shellInit

    # plugins for fish
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];

    # aliases (as ib bash)
    shellAliases = {
      ll = "ls -la";
      l = "ls -l";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      # cat = "bat";     # если поставишь bat
      nixup = "sudo nix flake update && sudo nixos-rebuild switch --flake .#thinkpad";
    };
  };

  # packages for user
  home.packages = with pkgs; [
    kitty

    # browser
    firefox

    # file manager
    thunar
    # gvfs # was added in configuration.nix, need for thunar needs

    # utils
    tree
    jq
    wofi
    waybar

    # pictures
    swayimg
    grim
    hyprshot # screenshots (Wayland)
    slurp          # set zone for screenshots

    # media
    mpv
    ffmpeg

    # fonts 
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # keeping secrets (optional)
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # configs for progs (by home manager)
  programs.git = {
    enable = true;
    userName = "YFDUO";
    userEmail = "xjchuepolska@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  # neovim minimal config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };


  # home catalogs
  home.stateVersion = "26.05";
}
