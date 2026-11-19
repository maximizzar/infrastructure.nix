# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.bat = {
    programs.bat = {
      enalbe = true;
      settings = {
        map-syntax =
          let
            base = "/etc/nginx";
            confd = base + "/conf.d";
            sitesa = base + "/sites-available";
            sitese = base + "/sites-enabled";
          in
          [
            "*.jenkinsfile:Groovy"
            "*.props:Java Properties"
            "*.ignore:Git Ignore"

            # Nginx
            "${base}/nginx.conf:nginx"
            "${confd}/*.conf:nginx"
            "${sitesa}/*.conf:nginx"
            "${sitese}/*.conf:nginx"
          ];
        pager = "less -FR";
        theme = "gruvbox-dark";
      };
    };
  };
}
