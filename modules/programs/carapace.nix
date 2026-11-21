# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.carapace =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment = {
        systemPackages = with pkgs; [ carapace ];
        variables.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
      };

      programs.bash.interactiveShellInit = lib.mkIf config.programs.bash.enable ''
        source <(carapace _carapace)
      '';
    };
}
