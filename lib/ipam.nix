{ ... }: let
  transitPrefix = "fd95:948f:5cae";
  overlayPrefix = "fd80:3aa8:691a";

in {
  transitIp = site: "${transitPrefix}::${toString site.id}";

  sitePrefix = site: "${overlayPrefix}:${toString site.id}::/56";
  subnet = site: net: "${overlayPrefix}:${toString site.id net.subnetId}::/64";
  routerIp = site: net: router: "${overlayPrefix}:${toString site.id net.subnetId}::${toString router.routerId}";
  hostIp = site: net: host: "${overlayPrefix}:${toString site.id net.subnetId}::${toString host.hostId}";
}
