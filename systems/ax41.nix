{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
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

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "nixos";

  # For home-manager to work.
  users.users.${flake.config.people.myself} = {
    name = flake.config.people.myself;
    home = "/Users/${flake.config.people.myself}";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
