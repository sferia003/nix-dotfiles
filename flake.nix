{
  description = "Stephen's nix-darwin + home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    codex-cli-nix.url = "github:sadjow/codex-cli-nix";

    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    system = "aarch64-darwin";
    username = "sferia";
    hostname = "Stephens-MacBook-Air";
  in
  {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs = {
        inherit inputs username;
      };

      modules = [
        ./darwin-configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs username;
          };
          home-manager.users.${username} = import ./home.nix;
        }
      ];
    };
  };
}
