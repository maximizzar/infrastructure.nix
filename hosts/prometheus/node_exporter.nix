# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  # Node Exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "cgroups"
      "systemd"
    ];

    extraFlags = [
      "--collector.netdev.device-exclude=^(veth|docker|podman|lo)"
      "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|run|var/lib/[docker|podman|containers])($|/)"
    ];

    openFirewall = true;
  };

}
