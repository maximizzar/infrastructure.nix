# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.starship = { config, ... }: {
    programs.starship = {
      enable = true;
      #enableBashIntegration = config.programs.bash.enable;
      #enableFishIntegration = config.programs.fish.enable;
      #enableZshIntegration = config.programs.zsh.enable;

      presets = [ ];
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;

        git_metrics = {
          disabled = false;
        };

        hostname = {
          ssh_only = false;
          style = "bold bright-black";
        };

        username = {
          format = "[$user]($style) at ";
          show_always = true;
        };
      };
    };
  };
}
