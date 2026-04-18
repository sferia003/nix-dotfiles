{ pkgs, inputs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    openssh
    ripgrep
    fd
    fzf
    zoxide
    jq
    tree
    bat
    eza
    tmux
  ];

  programs.git = {
    enable = true;
    settings = {
    user = {
      name = "Stephen Feria";
      email = "sferia003@gmail.com";
    };
    };
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "eza -la";
      gs = "git status";
      v = "nvim";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake .#Stephens-MacBook-Air";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    terminal = "screen-256color";
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        options = {
          number = true;
          relativenumber = true;
          shiftwidth = 2;
          tabstop = 2;
          expandtab = true;
          cmdheight = 0;
          scrolloff = 5;
        };

        telescope.enable = true;

        treesitter = {
          enable = true;
          grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
            bash
            fish
            json
            markdown
            markdown_inline
            toml
            yaml
          ];
        };

        languages.nix = {
          enable = true;
          treesitter.enable = true;
          lsp = {
            enable = true;
            servers = [ "nil" ];
          };
          format.enable = true;
          extraDiagnostics.enable = true;
        };

        utility.motion.flash-nvim.enable = true;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
