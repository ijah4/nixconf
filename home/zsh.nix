{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      export PATH=/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/system/sw/bin:/usr/local/bin:$PATH

      # Because, adding it in .ssh/config is not enough.
      # cf. https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
      export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    '';

    initExtra = ''
      # Show random quote: https://github.com/srid/actual
      exec elvish
    '';
  };
}
