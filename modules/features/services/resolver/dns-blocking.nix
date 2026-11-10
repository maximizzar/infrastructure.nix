# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.resolver =
    {
      config,
      lib,
      sources,
      ...
    }:
    let
      cfg = config.maximizzar.resolver;
      mkRpzFileEntry = list: ''
        -- version "${list.version}" (${list.date})
        rpzFile("${list.src}")
      '';
    in
    {
      config = lib.mkIf cfg.blocklists {
        services.pdns-recursor.luaConfig = ''
          ${mkRpzFileEntry sources.hagezi-doh}
          ${mkRpzFileEntry sources.hagezi-gambling}
          ${mkRpzFileEntry sources.hagezi-hoster}
          -- corporate tracing blocklists --

          ${mkRpzFileEntry sources.hagezi-native-amazon}
          ${mkRpzFileEntry sources.hagezi-native-apple}
          ${mkRpzFileEntry sources.hagezi-native-huawei}
          ${mkRpzFileEntry sources.hagezi-native-lgwebos}
          ${mkRpzFileEntry sources.hagezi-native-oppo-realme}
          ${mkRpzFileEntry sources.hagezi-native-roku}
          ${mkRpzFileEntry sources.hagezi-native-samsung}
          ${mkRpzFileEntry sources.hagezi-native-tiktok}
          ${mkRpzFileEntry sources.hagezi-native-vivo}
          ${mkRpzFileEntry sources.hagezi-native-winoffice}
          ${mkRpzFileEntry sources.hagezi-native-xiaomi}
        '';
      };
    };
}
