{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services.nginx = {
    enable = true;

    recommendedOptimisation = true;

    appendHttpConfig = ''
      sendfile on;
      tcp_nopush on;
      aio threads;

      limit_conn_zone $binary_remote_addr zone=conn_limit:10m;
    '';

    virtualHosts."static.maximizzar.org" = {
      enableACME = false;
      forceSSL = false;
    };
  };
}