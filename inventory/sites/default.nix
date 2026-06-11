{
  transitPrefix = "fd95:948f:5cae";
  overlayPrefix = "fd80:3aa8:691a";

  sites = {
    nbg = import ./nbg.nix;
    genesis = import ./genesis.nix;
  };
}
