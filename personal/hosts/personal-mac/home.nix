{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
  ];

  programs.zsh.shellAliases = {
    rebuild = "cd /private/etc/nix-darwin && sudo darwin-rebuild switch --flake path:/private/etc/nix-darwin#$(hostname -s)";
  };
}
