# SPDX-FileCopyrightText: 2026 maximizzar <mail.maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  systemd.services.nix-optimise.serviceConfig = {
    # Filesystem
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;

    # Kernel
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroup = true;
    ProtectClock = true;
    ProtectHostname = true;

    # Privileges
    NoNewPrivileges = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    LockPersonality = true;

    # Isolation
    PrivateIPC = true;
    ProtectProc = "invisible";

    # Syscalls
    SystemCallArchitectures = "native";
    RestrictAddressFamilies = [ "AF_UNIX" ];
  };
}
