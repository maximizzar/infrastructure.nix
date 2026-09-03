# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, ... }: {
  users.users.peter = {
    enable = lib.mkDefault false;
    description = "Peter";
    isNormalUser = true;
    hashedPassword = "$6$w8gjQiYDIn7vfwRJ$TUzIoGbLv1UliofRMFB7Fr7/dGFCkqrbBOVn4SP/Wn6dgyZpaGmSl7WIADU2.tHopAT0m4Rm8y93ly6JHX.Ry1";
    openssh.authorizedKeys.keys = [
    ];
  };
}
