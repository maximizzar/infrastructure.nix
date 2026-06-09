{ inputs, ...  }: let 
        hostname = "gw-nbg";
        domain = "core.maximizzar.org";
in {
    imports = [
        ./configuration.nix
	./disk-config.nix

        inputs.nixos-facter-modules.nixosModules.facter
        { hardware.facter.reportPath = ./facter.json; }
    ];
}
