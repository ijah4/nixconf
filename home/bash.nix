{
  programs.bash = {
    enable = true;
    initExtra = ''
      # Show random quote: https://github.com/srid/actual
      exec elvish
    '';};
}
