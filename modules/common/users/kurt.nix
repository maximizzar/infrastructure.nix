# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, ... }: {
  users.users.kurt = {
    enable = lib.mkDefault false;
    description = "Kurt";
    isNormalUser = true;
    hashedPassword = "$6$0GEcOgmQk/sMWbId$gXK88pWMbXHRqNG1yYiUJA9q5b4vRQppu0lu5Ifw7YGYwRr8Tbw8Snw6A0JNE6XjZnsSEaxzBg4NkcF9Lhssa.";
    openssh.authorizedKeys.keys = [
    ];
  };
}
