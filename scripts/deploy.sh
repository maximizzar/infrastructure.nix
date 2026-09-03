#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
just deploy-build-remote gw-nbg endpoint.nbg.prod.maximizzar.org
just deploy resolver resolver.genesis.prod.maximizzar.org
just deploy gw-genesis gw.dmz.genesis.prod.maximizzar.org
just deploy auth auth.dmz.genesis.prod.maximizzar.org
just deploy forgejo forgejo.srv.genesis.prod.maximizzar.org
