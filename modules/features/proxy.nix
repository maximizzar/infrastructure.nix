# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }:
{
  flake.nixosModules.proxy =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.maximizzar.proxy;
      services_domain = "services.genesis.maximizzar.org";
    in
    {
      imports = with self.nixosModules; [
        webServer
      ];

      options.maximizzar.proxy = {
        enable = lib.mkEnableOption "Enable a NGINX based reverse Proxy on this target";
        openFirewall = lib.mkEnableOption "Open common web-ports in FW";
        package = lib.mkOption {
          default = pkgs.nginxMainline;
          defaultText = lib.literalExpression "pkgs.nginxMainline";
          type = lib.types.package;
        };

        domain = lib.mkOption {
          type = lib.types.str;
          example = "example.org";
          description = "Public base domain of the vhosts (also the ACME host).";
        };

        hosts = lib.mkOption {
          default = { };
          description = "Reverse-proxied services, key = service name.";
          # `config` here is the submodule's own config and shadows the outer one;
          # that is why `cfg` is bound above.
          type = lib.types.attrsOf (
            lib.types.submodule (
              { name, config, ... }: {
                options = {
                  enable = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                  };

                  subdomain = lib.mkOption {
                    type = lib.types.str;
                    default = name;
                  };

                  backend = {
                    name = lib.mkOption {
                      type = lib.types.str;
                      default = config.subdomain;
                      description = "Hostname of the backend (the part before the domain).";
                    };
                    domain = lib.mkOption {
                      type = lib.types.str;
                      default = cfg.domain;
                      description = "Domain of the backend.";
                    };
                    port = lib.mkOption {
                      type = lib.types.port;
                      example = 443;
                    };
                  };

                  extra = lib.mkOption {
                    type = lib.types.attrs;
                    default = { };
                    description = "Merged over the generated vhost via recursiveUpdate.";
                  };

                };

              }
            )
          );

        };

      };

      config =
        let
          active = lib.filterAttrs (_: host: host.enable) cfg.hosts;
        in
        {
          services.nginx.upstreams = lib.mapAttrs' (
            name: host:
            lib.nameValuePair "${name}-backend" {
              servers."${host.backend.name}.${host.backend.domain}:${toString host.backend.port}" = { };
            }
          ) active;

          services.nginx.virtualHosts = lib.mapAttrs' (
            name: host:
            lib.nameValuePair "${name}-vhost" (
              lib.recursiveUpdate {
                serverName = "${host.subdomain}.${cfg.domain}";

                forceSSL = true;
                useACMEHost = cfg.domain;

                kTLS = true;
                quic = true;
                http3_hq = true;

                locations."/".proxyPass = "https://${name}-backend";
              } host.extra
            )
          ) active;
        };

    };
}
