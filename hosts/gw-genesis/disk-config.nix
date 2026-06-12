{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/vda";

    content = {
      type = "gpt";

      partitions = {
        esp = {
          priority = 1;
          size = "500M";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        root = {
          priority = 2;
          name = "root";
          size = "100%";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };
}
