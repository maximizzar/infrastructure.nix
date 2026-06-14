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

      root = "/srv/static";

      locations."/music/" = {
        extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;

          limit_conn conn_limit 20;
          limit_req zone=req_limit burst=50;
        '';
      };
    };
  };
}