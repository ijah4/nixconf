{ self, inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "24.05";
        imports = [
          # inputs.nixvim.homeManagerModules.nixvim
          inputs.nix-index-database.hmModules.nix-index
          ./_1password.nix
          ./ssh.nix
          ./starship.nix
          ./terminal.nix
          ./nix.nix
          ./git.nix
          ./direnv.nix
          ./zellij.nix
          ./just.nix
          ./elvish.nix
          ./emacs.nix
          # ./powershell.nix
          # ./juspay.nix
        ];
      };
      common-linux = {
        imports = [
          self.homeModules.common
          ./bash.nix
          # ./vscode-server.nix
        ];
      };
      common-darwin = {
        imports = [
          self.homeModules.common
          ./zsh.nix
        ];
      };
    };
  };
}
