{
  inputs,
  pkgs,
}:

pkgs.vimUtils.buildVimPlugin {
  pname = "codex.nvim";
  version = "unstable";
  src = inputs.codex-nvim;
}
