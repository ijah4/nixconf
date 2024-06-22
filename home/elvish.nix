{
  xdg.configFile."elvish" = {
    source = ./elvish;
    force = true;
  };
  #
  # inherit (config.home) shellAliases;
  programs.zsh.initExtra = ''
  '';
}
