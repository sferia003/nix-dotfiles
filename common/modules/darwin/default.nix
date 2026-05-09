{
  pkgs,
  username,
  ...
}:

{
  system.stateVersion = 6;

  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

  environment.systemPackages = with pkgs; [
    vim
  ];
}
