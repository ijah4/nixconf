{ flake, pkgs, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.darwinModules.default
    "${self}/nix-darwin/zsh-completion-fix.nix"
    # "${self}/nixos/github-runner.nix"
  ];

  environment.systemPackages = with pkgs; [
    elvish
    curl
    direnv
    fzf
    gnupg
    jq
    shellcheck
    zoxide
    nix-index

    (ripgrep.override { withPCRE2 = true; })
    fd
    sd
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "wAir";

  security.pam.enableSudoTouchIdAuth = true;

  # For home-manager to work.
  users.users.${flake.config.people.myself} = {
    name = flake.config.people.myself;
    home = "/Users/${flake.config.people.myself}";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
