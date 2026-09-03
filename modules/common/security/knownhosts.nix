# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.security.knownHosts;
in
{
  options.maximizzar.modules.security.knownHosts = {
    gitRemotes.enable = lib.mkEnableOption "Add Git-Remotes to knownHosts";
    guests.enable = lib.mkEnableOption "Add Virtual Machines to knownHosts";
    machines.enable = lib.mkEnableOption "Add Machines to knownHosts";
  };

  config = lib.mkMerge [

    (lib.mkIf cfg.gitRemotes.enable {
      programs.ssh.knownHosts = {
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
      };

    })

    (lib.mkIf cfg.guests.enable {
      programs.ssh.knownHosts = {
        resolver = {
          hostNames = [ "resolver.genesis.prod.maximizzar.org" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdt9P0b4Yw/sNpDopMZZWZ+HXx1OOlSeN9r/qadxlWl";
        };

        gw-genesis = {
          hostNames = [
            "gw.dmz.genesis.prod.maximizzar.org"
            "gw.srv.genesis.prod.maximizzar.org"
          ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjlnOofkSz/l5tYy6hlC7uzlJr2H6LL80tPF7VVJbLL";
        };

        ca = {
          hostNames = [ "root.ca.dmz.genesis.prod.maximizzar.org" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMCMTioIQY3Rk0+2LVr4JlaFTUgebv6a14lqjbiZh/m";
        };

      };
    })

    (lib.mkIf cfg.machines.enable {
      programs.ssh.knownHosts = {
        proxmox = {
          hostNames = [ "pve.infra.maximizzar.org" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpUHhah7wuMErerWPHUt6iL1SvY9htdcWuEOx1g4cuj";
        };

        mip3 = {
          hostNames = [ "mip3.infra.maximizzar.org" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+8/23V8YLU1CnMr7YnMy+YSRedmlXryHIgDmpSAZMw";
        };

      };
    })

  ];
}
