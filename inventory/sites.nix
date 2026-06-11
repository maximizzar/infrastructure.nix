{
  nbg = {
    id = 1;
    prefix = "fd80:3aa8:691a:01::/56";

    router = {
      hostname = "gw-nbg";
      wgPubkey = "M5D6n6anAAnLazg1uSv9yst7F2hdkdbGadcAsCm/KhM=";

      interfaces = {
        transit.address = "fd95:948f:5cae::1";
        lan = {
          address = "fd80:3aa8:691a:0101::1/64";
          network = "fd80:3aa8:691a:0101::/64";

        };
      };
    };
  };

  genesis = {
    id = 2;
    prefix = "fd80:3aa8:691a:02::/56";

    router = {
      hostname = "gw-genesis";
      wgPubkey = "HtZ5U/0OsQ6h0N/W9B/8YtARcMVbkKbKSDBkI8tFLmo=";

      interfaces = {
        transit.address = "fd95:948f:5cae::2";
        lan = {
          address = "fd80:3aa8:691a:0201::1/64";
          network = "fd80:3aa8:691a:0201::/64";
        };
      };
    };
  };
}
