# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.maximizzar.modules.profiles.plasmaDesktop;
in
{

  options.maximizzar.modules.profiles.plasmaDesktop = {
    enable = lib.mkEnableOption "KDE Plasma DE";
  };

  config = lib.mkIf cfg.enable {
    # Enable networking
    networking.networkmanager.enable = true;
    # Enable German locale settings
    maximizzar.modules.applications.deLocale.enable = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    maximizzar.modules.services.pipewire.enable = true;

    # Add Programms
    programs.firefox.enable = true;
    programs.chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = true;
    };

    programs.kdeconnect.enable = true;
    programs.mtr.enable = true;
    maximizzar.modules.applications.ksshaskpass.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      # Cli tooling
      wget
      curl
      dnsutils

      dust
      just

      # Office
      libreoffice
      thunderbird

      kdePackages.kcalc
      kdePackages.korganizer
    ];

    fonts = {
      enableDefaultPackages = true; # Ensures basic UI fonts exist
      fontDir.enable = true; # Dynamically links fonts to /run/current-system/sw/share/X11/fonts
    };

  };
}
