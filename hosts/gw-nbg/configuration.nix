{
  modulesPath,
  lib,
  pkgs,
  inventory,
  ...
}@args: let
nbg-lan-hosts = inventory.sites.nbg.router.interfaces.lan.hosts;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  services.qemuGuest.enable = true; # config.facter.virtualisation == "kvm";

  security.sudo.wheelNeedsPassword = false;

  # enable maximizzar user
  maximizzar.modules.users.maximizzar.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  # Test subnet behind wg with web containers
  containers.ns1 = {
    privateNetwork = true;
    extraVeths.veth0.hostBridge = "br-lan";

    specialArgs = {
      inventory = inventory;
    };

    config = { ... }: {
      networking.useDHCP = false;
      networking.useNetworkd = true;

      systemd.network.enable = true;
      services.resolved.enable = false;

      systemd.network.networks."10-veth0" = {
        matchConfig.Name = "veth0";

        address = [ "${nbg-lan-hosts.ns1.ip}/64" ];
        routes = [{ Gateway = nbg-lan-hosts.gw.ip; }];

        networkConfig = {
          IPv6AcceptRA = false;
        };
      };

      imports = [ ./nameserver.nix ];
      system.stateVersion = "26.05";
    };
  };
}
