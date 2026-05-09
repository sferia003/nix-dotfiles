{
  description = "Stephen's shared Nix modules and personal nix-darwin config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      mkDarwinSystem =
        {
          system,
          username,
          extraDarwinModules ? [ ],
          extraHomeModules ? [ ],
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = (_: true);
            };
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit system pkgs;

          specialArgs = {
            inherit inputs self username;
          };

          modules = [
            self.darwinModules.default
          ] ++ extraDarwinModules ++ [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs self username;
              };
              home-manager.users.${username}.imports = [
                self.homeModules.default
              ] ++ extraHomeModules;
            }
          ];
        };

    in
    {
      homeModules.default = import ./common/modules/home;
      darwinModules.default = import ./common/modules/darwin;

      lib = {
        inherit mkDarwinSystem;
      };

      darwinConfigurations."Stephens-MacBook-Air" = mkDarwinSystem {
        system = "aarch64-darwin";
        username = "sferia";
        extraDarwinModules = [ ./personal/hosts/personal-mac/system.nix ];
        extraHomeModules = [
          ./personal/profiles/default.nix
          ./personal/hosts/personal-mac/home.nix
        ];
      };

      formatter.aarch64-darwin =
        (import nixpkgs {
          system = "aarch64-darwin";
          config = { };
        }).nixfmt-tree;
    };
}
