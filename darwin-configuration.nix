{
  pkgs,
  username,
  ...
}:

{
  system.stateVersion = 6;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # Mac/system-level things

  programs.zsh.enable = true;
  programs.fish.enable = true;

  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

  environment.systemPackages = with pkgs; [
    vim
    alacritty
    alacritty.terminfo
  ];

}
