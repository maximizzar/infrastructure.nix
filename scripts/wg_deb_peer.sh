#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

install() {
	sudo apt install wireguard
	sudo systemctl enable wg-quick@wg0
}

config() {
	local wireguard_config_dir="/etc/wireguard"
	local wireguard_config_temp wireguard_priv_key
	wireguard_config_temp="$(mktemp --directory)"
	wireguard_priv_key="$(wg genkey)"

	# Create in tmp so shell redirect still works as normal user
	cat >"${wireguard_config_temp}/wg0.conf" <<-EOF
		[Interface]
		ListenPort = 51820
		PrivateKey = ${wireguard_priv_key}"

		[Peer]
		PublicKey = M5D6n6anAAnLazg1uSv9yst7F2hdkdbGadcAsCm/KhM=
		AllowedIPs = fd80:3aa8:691a::/48, fd95:948f:5cae::2/128
		Endpoint = [2a01:4f8:c2c:bd86:a2:57ff:fea0:dd70]:51820
		PersistentKeepalive = 25
	EOF

	# Create wireguard config dir
	sudo mkdir -p "$wireguard_config_dir"

	# Set user permissions and move file to destination
	sudo chmod 0600 "$wireguard_config_temp}/wg0.conf"
	sudo chown 0:0 "${wireguard_config_temp}/wg0.conf"
	sudo mv "${wireguard_config_temp}/wg0.conf" "${wireguard_config_dir}/wg0.conf"

	# Print pubkey to stdout
	echo "${wireguard_priv_key}" | wg pubkey
}

main() {
	install
	config
}

main "$@"
