{ pkgs, username, self, ... }:

{
  system.stateVersion = 6;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.${username} = {
    home = "/Users/${username}";
  };

  # Mac/system-level things
  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

}
