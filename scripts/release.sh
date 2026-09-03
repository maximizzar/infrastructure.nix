#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

if [[ -z "${FORGEJO_TOKEN:-}" ]]; then
  echo "❌ Fehler: FORGEJO_TOKEN ist nicht gesetzt!"
  exit 1
fi

# GoReleaser erwartet das Token in GITEA_TOKEN für Forgejo/Gitea-Instanzen
export GITEA_TOKEN="$FORGEJO_TOKEN"

echo "🚀 Starte GoReleaser für Forgejo..."
goreleaser release --clean
