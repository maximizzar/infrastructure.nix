{ ... }: {
    flake.nixosModules.services-prometheus-client = { config, hostname, domain, ... }: let
        fqdn = "metrics.${hostname}.${domain}";
    in {
        networking.firewall.allowedTCPPorts = [ 9100 ];

        # Run node exporter on localhost only
        services.prometheus.exporters.node = {
            enable = true;
            enabledCollectors = [ "systemd" "processes" ];
            port = 9180;
            listenAddress = "127.0.0.1";
        };

        # NGINX base config (For now here!)
        services.nginx = {
            enable = true;
            validateConfigFile = true;

            recommendedTlsSettings = true;
            recommendedOptimisation = true;
            recommendedGzipSettings = true;
            recommendedUwsgiSettings = true;
            recommendedBrotliSettings = true;
            recommendedProxySettings = true;
        };

        security.acme.certs."${fqdn}" = {
            domain = "${fqdn}";
            webroot = "/var/lib/acme/acme-challenge";
            group = "nginx";
            postRun = "systemctl reload prometheus-exporter.service";
        };

        # Nginx vHost for ACME web challenge
        services.nginx.virtualHosts."${fqdn}" = {
            locations."/.well-known/acme-challenge" = {
                root = "/var/lib/acme/acme-challenge";
            };
        };

        # Nginx vHost for /metric endpoint
        services.nginx.virtualHosts."${fqdn}-metrics" = {
            serverName = "${fqdn}";

            sslCertificate = "/var/lib/acme/${fqdn}/fullchain.pem";
            sslCertificateKey = "/var/lib/acme/${fqdn}/key.pem";
            sslTrustedCertificate = "/var/lib/acme/${fqdn}/chain.pem";

            listen = [
                { addr = "[::]"; port = 9100; ssl = true; }
            ];

            enableACME = true;
            forceSSL = true;

            locations."/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.prometheus.exporters.node.port}";
            };
        };
    };
}
