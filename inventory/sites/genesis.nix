{
  id = 2;

  primaryRouter = "gw-genesis";
  routers.gw-genesis = {
    routerId = 1;

    wg = {
      pubkey = "...";
    };
  };

  networks = {
    core = {
      subnetId = 10;
    };

    servers = {
      subnetId = 20;
    };
  };

  hosts = {
    ns1 = {
      network = "core";
      hostId = 53;
    };
    vm1 = {
      network = "servers";
      hostId = 10;
    };
  };
}
