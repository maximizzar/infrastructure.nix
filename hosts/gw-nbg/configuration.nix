{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
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
  containers.web1 = {
    privateNetwork = true;
    hostAddress6 = "fd80:3aa8:691a:0101::1";
    localAddress6 = "fd80:3aa8:691a:0101::10";

    config = { ... }: {
      services.nginx.enable = true;
      services.nginx.virtualHosts.localhost = {
        root = pkgs.runCommand "web" {} ''
          mkdir -p $out
          echo "hello container web1" > $out/index.html
        '';
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      system.stateVersion = "26.05";
    };
  };
}
