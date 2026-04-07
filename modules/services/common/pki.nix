# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/common/pki.nix
{ config, pkgs, lib, ... }:

{

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "admin@maximizzar.org";
      server = "https://root.ca.maximizzar.org/acme/acme/directory";
    };
  };

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIB2DCCAX2gAwIBAgIQJonwj65QMXgj0jUe/Y5bmTAKBggqhkjOPQQDAjBKMR8w
      HQYDVQQKExZtYXhpbWl6emFyLm9yZyBSb290IENBMScwJQYDVQQDEx5tYXhpbWl6
      emFyLm9yZyBSb290IENBIFJvb3QgQ0EwHhcNMjYwMzEyMTAzMzI2WhcNMzYwMzA5
      MTAzMzI2WjBKMR8wHQYDVQQKExZtYXhpbWl6emFyLm9yZyBSb290IENBMScwJQYD
      VQQDEx5tYXhpbWl6emFyLm9yZyBSb290IENBIFJvb3QgQ0EwWTATBgcqhkjOPQIB
      BggqhkjOPQMBBwNCAAR6NHx6Sa44uz5CWctuqNfr6hJP0gQEfo+jPqFM+8I+/LoJ
      2uvhza1dRGrvZHxybVXieIrE/0Dt76w2iCWnec2wo0UwQzAOBgNVHQ8BAf8EBAMC
      AQYwEgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQUjLLGcDPjZ7IjEEVJ6Z6T
      Uac5ld4wCgYIKoZIzj0EAwIDSQAwRgIhAPnG8wHLGEC4dyHaE5xuQuyITUduqnth
      +LtHouz9A+7KAiEAoXwdalR/6meA2WSG0NazAiZkZ4YZfHK1ohY0MuTJC/0=
      -----END CERTIFICATE-----
    ''
  ];
}
