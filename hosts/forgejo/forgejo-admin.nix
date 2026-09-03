# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.forgejo;

in
{
  sops.secrets."forgejo_admin/name" = {
    owner = "forgejo";
  };

  sops.secrets."forgejo_admin/password" = {
    owner = "forgejo";
  };

  systemd.services.forgejo.preStart =
    let
      adminCmd = "${lib.getExe cfg.package} admin user";
      pwd = config.sops.secrets."forgejo_admin/password";
      user = config.sops.secrets."forgejo_admin/name";
    in
    ''
      ${adminCmd} create \
        --admin \
        --email "root@localhost" \
        --username "$(tr -d '\n' < ${user.path})" \
        --password "$(tr -d '\n' < ${pwd.path})" || true

      #${adminCmd} change-password --username ${user.path} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';
}
