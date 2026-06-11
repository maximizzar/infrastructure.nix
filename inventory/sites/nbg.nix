{
  id = 1;

  primaryRouter = "gw-nbg";
  routers.gw-nbg = {
    routerId = 1;

    wg = {
      endpoint = "gw-nbg.maximizzar.org";
      pubkey = "...";
    };
  };
}
