{
  pkgs,
  inputs,
  username,
  ...
}:

{
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    nixfmt
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
    sioyek
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-medium latexmk lingmacros;
    })
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
        "zoxide"
      ];
      theme = "lambda";
    };

    shellAliases = {
      cd = "z";
      cat = "bat";
      ls = "eza --long --binary --group";
    };
  };

  programs.alacritty.enable = true;

  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    theme = {
      mode = {
        normal_main.bg = "#121212";
        normal_alt.bg = "#1f1f1f";
      };
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    terminal = "screen-256color";
    extraConfig = builtins.readFile ../../../common/tmux.conf;
  };

  programs.nvf = {
    enable = true;

    settings.vim = {
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

      dashboard.dashboard-nvim = {
        enable = true;
        setupOpts = {
          theme = "doom";
          config = {
            header = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              "                               __                "
              "  ___     ___    ___   __  __ /\\_\\    ___ ___    "
              " / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  "
              "/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ "
              "\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\"
              " \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/"
              ""
              ""
            ];
            center = [
              {
                desc = "Find files";
                key = "f";
                action = "Telescope find_files";
              }
              {
                desc = "Recent files";
                key = "r";
                action = "Telescope oldfiles";
              }
              {
                desc = "Search text";
                key = "g";
                action = "Telescope live_grep";
              }
              {
                desc = "New file";
                key = "n";
                action = "enew";
              }
              {
                desc = "Quit";
                key = "q";
                action = "qa";
              }
            ];
          };
        };
      };

      keymaps = [
        {
          key = "<leader>d";
          mode = "n";
          silent = true;
          action = "<cmd>lua vim.diagnostic.open_float(nil, { scope = 'line' })<CR>";
          desc = "Show line diagnostics";
        }
        {
          key = "<leader>e";
          mode = "n";
          silent = true;
          action = "<cmd>Yazi<CR>";
          desc = "Open Yazi";
        }
      ];

      extraPlugins = {
        vimtex = {
          package = pkgs.vimPlugins.vimtex;
          setup = ''
            vim.g.maplocalleader = "\\"
            vim.g.vimtex_view_method = "sioyek"
            vim.g.vimtex_compiler_method = "latexmk"
          '';
        };
        claude-code-nvim = {
          package = pkgs.vimPlugins.claude-code-nvim;
          setup = ''
            require("claude-code").setup({
              window = {
                position = "float"
              },
              keymaps = {
                toggle = {
                  normal = "<leader>\\",
                  terminal = "<leader>\\",
                },
              },
            })
          '';
        };
        yazi-nvim = {
          package = pkgs.vimPlugins.yazi-nvim;
          setup = ''
            require("yazi").setup({
              open_for_directories = true,
              set_keymappings_function = function(yazi_buffer_id, _config, _context)
                vim.keymap.set("t", "<leader>e", function()
                  local job_id = vim.b.terminal_job_id
                  if job_id then
                    vim.api.nvim_chan_send(job_id, "q")
                  end
                end, { buffer = yazi_buffer_id, desc = "Close Yazi" })
              end,
            })
          '';
        };
      };

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
        format = {
          enable = true;
          type = [ "nixfmt" ];
        };
        extraDiagnostics.enable = true;
      };

      lsp = {
        enable = true;
        formatOnSave = true;
      };

      git.gitsigns.enable = true;

      utility.motion.flash-nvim.enable = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
