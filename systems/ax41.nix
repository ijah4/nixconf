{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    "${self}/nixos/nix.nix"
  ];

  system.stateVersion = "24.05";
  networking.hostName = "nixos";
  nixpkgs.hostPlatform = "x86_64-linux";
}
