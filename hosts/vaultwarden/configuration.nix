# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  modulesPath,
  lib,
  stateVersion,
  config,
  ...
}:
let
  fqdn = "vaultwarden.dmz.genesis.maximizzar.org";
  cfg = config.services.vaultwarden.config;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Hardware configuration
  maximizzar.modules.hardware = {
    bootSystemd.enable = lib.mkDefault true;
    configuration.qemu.enable = lib.mkDefault true;
    rootDisk.enable = lib.mkDefault true;
  };

  # Core Services
  services = {
    openssh.enable = lib.mkDefault true;
    qemuGuest.enable = lib.mkDefault true;
  };

  # Networking
  networking.hostName = "vaultwarden";
  maximizzar.networking.vmNetworking.enable = true;

  # User Settings
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  users.users.maximizzar.enable = true;
  system.stateVersion = stateVersion;

  # Vaultwarden Service
  services.vaultwarden.enable = true;
  services.vaultwarden = {
    configurePostgres = true;

    dbBackend = "postgresql";
    domain = "vault.maximizzar.org";
  };

  # Local proxy to have easier Tls config
  services.nginx.enable = true;
  services.nginx.virtualHosts."/" = {
    default = true;
    serverName = fqdn;

    sslCertificate = "/var/lib/acme/${fqdn}/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/${fqdn}/key.pem";
    sslTrustedCertificate = "/var/lib/acme/${fqdn}/chain.pem";

    forceSSL = true;
    enableACME = true;

    quic = true;
    extraConfig = ''
      add_header Alt-Svc 'h3=":443"; ma=86400' always;
    '';

    #locations."/".proxyPass = "http://${cfg.ROCKET_ADDRESS}:${cfg.ROCKET_PORT}";
    locations."/".proxyPass = "http://[::1]:8222";
  };
}
