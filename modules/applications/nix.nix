# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ ... }: {
  nix = {
    enable = true;

    gc = {
      automatic = true;
      persistent = true;
      randomizedDelaySec = "1800";
    };

    optimise = {
      automatic = true;
      dates = [
        "04:45"
      ];

      persistent = true;
      randomizedDelaySec = "1800";
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "maximizzar"
    ];

  };

  nix.settings.substituters = [
    "https://cache.nixos.org"
  ];

  system.stateVersion = "26.05";
}
