# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, ... }: {
  users.users.bytedream = {
    enable = lib.mkDefault false;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADzKEPdW0d6SQKh8Hp3dDWPX0AN+XQKVGu3FWRSXlCl bytedream@nyachyos"
    ];
  };
}
