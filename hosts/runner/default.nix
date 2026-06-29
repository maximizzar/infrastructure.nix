{ pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  systemd.services.forgejo-runner = {
    description = "forgejo-runner";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      bash
      coreutils
      git
      nodejs
      pkgs.forgejo-runner
      nix
      "/run/current-system/sw"
    ];

    environment = {
      FORGEJO_INSTANCE_URL = "https://forgejo.maximizzar.io";
      NIX_REMOTE = "daemon";
    };

    serviceConfig = {
      Type = "simple";

      # Wir erzwingen ROOT, um jede Art von Berechtigungsproblem auszuschließen
      User = "root";
      Group = "root";

      # Das Arbeitsverzeichnis, in dem die Registrierungsdaten (.runner) landen
      WorkingDirectory = "/var/lib/forgejo-runner";

      # Lädt dein Token direkt aus der Datei als Umgebungsvariable $TOKEN
      EnvironmentFile = "/var/secrets/forgejo-runner/token";

      # Der eigentliche Startbefehl:
      # Erst registrieren (falls nötig), dann den Daemon starten.
      #ExecStartPre = "${pkgs.forgejo-runner}/bin/forgejo-runner register --no-interactive --instance $FORGEJO_INSTANCE_URL --token $TOKEN --name nixos-manual-runner --labels self-hosted:host,nixos:host";
      ExecStart = "${pkgs.forgejo-runner}/bin/forgejo-runner daemon --url https://forgejo.maximizzar.io/ --uuid b994f831-d0d1-49c8-a5ec-19a7f6b7606c --token-url file:///var/secrets/forgejo-runner/token --label nixos:host";

      Restart = "always";
      RestartSec = "5s";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/forgejo-runner 0700 root root - -"
  ];
}
