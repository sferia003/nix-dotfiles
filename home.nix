{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
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
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
