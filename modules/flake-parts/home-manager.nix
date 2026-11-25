# SPDX-FileCopyrightText: 2026 maximizzar <mail.maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inputs, ... }: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
