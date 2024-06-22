{ config, pkgs, lib, ... }:

# Platform-independent terminal setup
{
  home.packages = with pkgs; [
    # Unixy tools
    moreutils # ts, etc.
    graphviz

    # Useful for Nix development
    nixci
    nix-health
    nixpkgs-fmt
    just

    # Publishing
    asciinema
    # twitter-convert

    # Fonts
    cascadia-code
  ];

  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  home.shellAliases = rec {
    l = lib.getExe pkgs.lsd;
    t = tree;
    tree = "${lib.getExe pkgs.lsd} --tree";
    beep = "say 'beep'";
    g = "git";
    v = "vim";
    vf = "vim $(fzf)";
  };

  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    nix-index-database.comma.enable = true;
    lsd = {
      enable = true;
      enableAliases = true;
    };
    bat.enable = true;
    autojump.enable = false;
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;
    htop.enable = true;
  };
}
