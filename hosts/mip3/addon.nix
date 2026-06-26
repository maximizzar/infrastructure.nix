# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ pkgs, ... }: {
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    # bitwarden-desktop # currently insecure Electorn version
    git
    ffmpeg

    kdePackages.ksshaskpass
    home-manager
    keepassxc

    jellyfin-desktop
    steam
    itch

    maple-mono.NF-CN
    libreoffice

    # Rust cli tools
    bandwhich
    dust
    just
  ];

  environment.sessionVariables = {
    SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  programs.ssh.knownHosts = {
    #
    # Git remotes
    #

    codeberg = {
      hostNames = [ "codeberg.org" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVIC02vnjFyL+I4RHfvIGNtOgJMe769VTF1VR4EB3ZB";
    };

    forgejo = {
      hostNames = [ "ssh.forgejo.maximizzar.io" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhfTDt0pHZ92otpjS8nu7BLE7F+obi+rTzlctcHYHWb";
    };

    github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };

    #
    # Machines
    #

    proxmox = {
      hostNames = [ "pve.maximizzar.io" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpUHhah7wuMErerWPHUt6iL1SvY9htdcWuEOx1g4cuj";
    };
  };
}
