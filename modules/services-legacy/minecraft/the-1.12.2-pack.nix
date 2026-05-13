# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, lib, ... }

{
  services.minecraft-server = {
    dataDir = "/var/lib/minecraft/the-1.12.2-pack";
    declarative = true;
    enable = true;
    eula = true;

    jvmOpts = "-Xmx4096M -Xms4096M";
    openFirewall = true;
    package = pkgs.minecraftServers.forge-1_12_2;

    serverProperties = {
      allow-flight = true;
      allow-nether = true;
      broadcast-console-to-ops = true;
      difficulty = 2;
      enable-command-block = false;
      enable-rcon = false;
      enable-query = true;
      force-gamemode = false;
      gamemode = 0;
      generate-structures = true;
      hardcore = false;
      level-name = "world";
      level-seed = 5438749486633290539;
      level-type = BIOMESOP;
      max-build-height = 256;
      max-players = 10;
      max-tick-time = -1;
      max-world-size = 29999984;
      motd = "\u00A7lThe 1.12.2 Pack Server v1.3.7 by maximizzar";
      network-compression-threshold = 256;
      online-mode = true;
      op-permission-level = 3;
      player-idle-timeout = 0;
      prevent-proxy-connections = false;
      pvp = true;
      query.port = 25565;
      server-ip = "0.0.0.0";
      server-port = 25565;
      snooper-enabled = true;
      spawn-animals = true;
      spawn-monsters = true;
      spawn-npcs = true;
      use-native-transport = true;
      view-distance = 12;
      white-list = true;
    };
    whitelist = {
      maximizzar = "5b5f7126-eb0d-4d96-b5f8-b39de41d6f36",
      Davenxe = "cf079a1c-ff47-4989-9ce7-48a89c5a9738",
      Ithareal = "f8d44d38-28ed-4a28-a589-f5af1feedecc",
    };
  };
}
