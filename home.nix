{
  pkgs,
  inputs,
  username,
  ...
}:

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
    pkgs.nixfmt
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
      rebuild = "z /etc/nix-darwin && sudo darwin-rebuild switch --flake .#Stephens-MacBook-Air";
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    theme = {
      mode = {
        normal_main = {
          bg = "#121212";
        };
        normal_alt = {
          bg = "#1f1f1f";
        };
      };
    };
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

        autocomplete.blink-cmp.enable = true;

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
          {
            key = "<leader>\\";
            mode = "n";
            silent = true;
            action = "<cmd>CodexToggle<CR>";
            desc = "Toggle Codex";
          }
        ];

        extraPlugins = {
          codex-nvim = {
            package = import ./pkgs/codex-nvim.nix { inherit inputs pkgs; };
            setup = ''
              require("codex").setup({
                keymaps = {
                  toggle = nil,
                  quit = "<leader>\\",
                },
                border = "rounded",
                width = 0.9,
                height = 0.9,
                cmd = "codex",
                autoinstall = false,
                panel = false,
                use_buffer = false,
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

        utility.motion.flash-nvim.enable = true;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
