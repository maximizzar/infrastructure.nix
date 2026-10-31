# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.kdePlasma =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.audio
      ];

      # Enable networking
      networking.networkmanager.enable = lib.mkDefault true;

      services = {
        # Enable the X11 windowing system.
        xserver.enable = true;

        # Enable the KDE Plasma Desktop Environment.
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;

        # Enable CUPS to print documents.
        printing = {
          enable = true;
          drivers = with pkgs; [ gutenprint ];
          cups-pdf.enable = true;
        };
      };

      # Add Programms
      programs = {
        firefox.enable = true;
        chromium = {
          enable = true;
          enablePlasmaBrowserIntegration = true;
        };

        kdeconnect.enable = true;
        mtr.enable = true;
      };

      # Use k-ssh ask-pass to store ssh passphrases in keyring
      environment.sessionVariables = {
        SSH_ASKPASS = lib.mkDefault "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
        SSH_ASKPASS_REQUIRE = lib.mkDefault "prefer";
      };

      # Allow unfree packages
      nixpkgs.config.allowUnfree = lib.mkDefault true;

      environment.systemPackages = with pkgs; [
        # Office
        libreoffice
        thunderbird

        # Extra KDE Packages
        kdePackages.kcalc
        kdePackages.korganizer
        kdePackages.ksshaskpass
      ];

      fonts = {
        enableDefaultPackages = true; # Ensures basic UI fonts exist
        fontDir.enable = true; # Dynamically links fonts to /run/current-system/sw/share/X11/fonts
      };

    };
}
