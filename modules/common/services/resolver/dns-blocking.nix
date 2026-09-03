# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  lib,
  sources,
  ...
}:
let
  cfg = config.maximizzar.modules.services.resolver;
in
{
  config = lib.mkIf cfg.blocklists.enable {
    # Install blocklists (rpz)
    environment.etc = {
      "dns-blocklists/doh.txt".source = sources.hagezi-doh.src;
      "dns-blocklists/gambling.txt".source = sources.hagezi-gambling.src;
      "dns-blocklists/hoster.txt".source = sources.hagezi-hoster.src;
      "dns-blocklists/native.amazon.txt".source = sources.hagezi-native-amazon.src;
      "dns-blocklists/native.apple.txt".source = sources.hagezi-native-apple.src;
      "dns-blocklists/native.huawei.txt".source = sources.hagezi-native-huawei.src;
      "dns-blocklists/native.lgwebos.txt".source = sources.hagezi-native-lgwebos.src;
      "dns-blocklists/native.oppo-realme.txt".source = sources.hagezi-native-oppo-realme.src;
      "dns-blocklists/native.roku.txt".source = sources.hagezi-native-roku.src;
      "dns-blocklists/native.samsung.txt".source = sources.hagezi-native-samsung.src;
      "dns-blocklists/native.tiktok.extended.txt".source = sources.hagezi-native-tiktok.src;
      "dns-blocklists/native.vivo.txt".source = sources.hagezi-native-vivo.src;
      "dns-blocklists/native.winoffice.txt".source = sources.hagezi-native-winoffice.src;
      "dns-blocklists/native.xiaomi.txt".source = sources.hagezi-native-xiaomi.src;
    };

    services.pdns-recursor.luaConfig = builtins.readFile ./rpz.lua;
  };

}
