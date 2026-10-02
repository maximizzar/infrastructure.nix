# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  services.paperless = {
    enable = true;

    domain = "paperless.maximizzar.org";

    mediaDir = "/mnt/documents";
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];

      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };

    };

    passwordFile = "";

    configureTika = true;
    configureNginx = false;
    database.createLocally = true;

  };
}
