{ ... }:
let
  fqdn = "prometheus.maximizzar.org";
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  #security.acme.certs."${fqdn}" = {
  #domain = fqdn;
  #webroot = "/var/lib/acme/acme-challenge";
  #postRun = "systemctl reload prometheus && systemctl reload nginx";
  #};

  services.nginx.enable = true;
  services.nginx.virtualHosts."prometheus-web" = {
    serverName = fqdn;

    sslCertificate = "/var/lib/acme/${fqdn}/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/${fqdn}/key.pem";
    sslTrustedCertificate = "/var/lib/acme/${fqdn}/chain.pem";

    enableACME = true;
    forceSSL = true;

    quic = true;
    extraConfig = ''
      add_header Alt-Svc 'h3=":443"; ma=86400' always;
    '';

    locations."/" = {
      proxyPass = "http://[::1]:9090";
    };

    locations."/.well-known/acme-challenge" = {
      root = "/var/lib/acme/acme-challenge";
    };
  };

  services.prometheus.enable = true;
  services.prometheus.scrapeConfigs = [
    {
      job_name = "prometheus";
      static_configs = [ { targets = [ "${fqdn}:443" ]; } ];
    }

    {
      job_name = "prometheus-host";
      static_configs = [ { targets = [ "[fd19:38bc:a21d:1abf:685d:9eff:fed5:5744]:9100" ]; } ];
    }

  ];
}
