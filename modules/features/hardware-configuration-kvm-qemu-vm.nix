{ self, inputs, ... }: {
  flake.nixosModules.hardwareConfigurationKvmQemuVm = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.systemdBoot

      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
    ];

    hardware.facter.reportPath = ./_facter.json;
    boot.growPartition = true;
    fileSystems."/" = {
      autoResize = true;
      label = "nixos-root";
    };

    disko.devices.disk.main.imageSize = lib.mkDefault "8G";
    disko.imageBuilder.imageFormat = "qcow2";

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/vda";

      content = {
        type = "gpt";

        partitions = {
          esp = {
            priority = 1;
            size = "512M";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            priority = lib.mkDefault 2;
            name = "root";
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
              extraArgs = [
                "-L"
                "nixos-root"
              ];
              mountpoint = "/";
              mountOptions = [ "noatime" ];
            };
          };
        };
      };
    };

  };
}
