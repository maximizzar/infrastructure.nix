# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.nixosModules.nvim = {
    imports = [ inputs.nvf.nixosModules.default ];
    programms.nvf = {
      enable = true;
      settings = lib.mkDefault config.flake.nvfModules.default;
    };
  };

  flake.nvfModules.default = { pkgs, ... }: {
    vim = {
      viAlias = true;
      vimAlias = true;
      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lightbulb = {
          enable = true;
          autocmd.enable = true;
        };
      };

      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
        transparent = true;
      };

      options = {
        autoindent = true;
        wrap = false;
        tabstop = 4;
        shiftwidth = 4;
        termguicolors = true;
      };

      syntaxHighlighting = true;
      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;

      keymaps = [
        {
          key = "<Esc>";
          mode = "n";
          action = "<cmd>nohlsearch<CR>";
          silent = true;
        }
      ];

      extraPlugins = with pkgs.vimPlugins; {
        neogen = {
          package = neogen;
          setup = ''
            require("neogen").setup({
              enabled = true,
              snippet_engine = "nvim",
            })
          '';
        };

      };
    };
  };

  flake.nvfModules.dev = {
    imports = [ config.flake.nvfModules.default ];
    vim.languages = {
      rust.enable = true;
      nix.enable = true;
    };
  };

  perSystem = { pkgs, ... }: {
    packages.nvim =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ config.flake.nvfModules.default ];
      }).neovim;

    packages.nvim-dev =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ config.flake.nvfModules.dev ];
      }).neovim;
  };
}
