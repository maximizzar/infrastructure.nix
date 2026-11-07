# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
  flake-parts-lib,
  inputs,
  self,
  ...
}:
{
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    deploy.nodes = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
    };
  };

  config.perSystem = { system, ... }: {
    checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
  };
}
