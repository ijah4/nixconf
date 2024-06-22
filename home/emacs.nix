# On macOS, launch Emacs using Raycast launcher.
# Or:
#
#   open -a ~/Applications/Home\ Manager\ Apps/Emacs.app
{ config, pkgs, lib, flake, ... }:

with lib; let
  envExtra = ''
    export PATH="${config.xdg.configHome}/emacs/bin:$PATH"
  '';
  shellAliases = {
    e = "emacsclient --create-frame &"; # gui
    et = "emacsclient --create-frame --tty"; # termimal
    ef = "et $(fzf)";
  };
  myEmacsPackagesFor = emacs: ((pkgs.emacsPackagesFor emacs).emacsWithPackages (epkgs: [
    epkgs.vterm
  ]));

  # macport adds some native features based on GNU Emacs 29
  # https://bitbucket.org/mituharu/emacs-mac/src/master/README-mac
  emacsPkg = myEmacsPackagesFor pkgs.emacs29-pgtk;
in
{

  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
  home.packages = (with pkgs; [
    ## Doom dependencies
    gnutls # for TLS connectivity

    ## Optional dependencies
    imagemagick # for image-dired
    zstd # for undo-fu-session/undo-tree compression

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    # :tools editorconfig
    editorconfig-core-c # per-project style config
    # :tools lookup & :lang org +roam
    sqlite
    # :lang latex & :lang org (latex previews)
    texlive.combined.scheme-medium
  ]) ++ [ emacsPkg ];

  programs.bash.bashrcExtra = envExtra;
  programs.zsh.envExtra = envExtra;
  home.shellAliases = shellAliases;

  # allow fontconfig to discover fonts and configurations installed through `home.packages`
  fonts.fontconfig.enable = true;

  #   xdg.configFile."doom" = {
  #     source = ./emacs/doom;
  #     force = true;
  #   };
  #   home.activation.installDoomEmacs = hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ${pkgs.rsync}/bin/rsync -avz --chmod=D2755,F744 ${flake.inputs.doomemacs}/ ${config.xdg.configHome}/emacs/
  # '';

  services.emacs = mkIf pkgs.stdenv.isLinux {
    enable = true;
    package = emacsPkg;
    client = {
      enable = true;
      arguments = [ " --create-frame" ];
    };
    startWithUserSession = true;
  };

  launchd = mkIf pkgs.stdenv.isDarwin {
    enable = true;
    agents.emacs = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.bash}/bin/bash"
          "-l"
          "-c"
          "${emacsPkg}/bin/emacs --fg-daemon"
        ];
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/emacs-daemon.stderr.log";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/emacs-daemon.stdout.log";
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
