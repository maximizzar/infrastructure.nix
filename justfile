default:
    just --list

# Build a QCow2 Disk-Image
build-disk-image flake:
    nix build .#{{ flake }}-image

# Push a QCow2 Disk-Image to a remote
push-disk-image host remote_path:
    scp result/main.qcow2 {{ host }}:{{ remote_path }}

# Deploy a flake target to a remote
deploy flake host:
    nixos-rebuild switch --flake .#{{ flake }} --target-host "{{ host }}" --sudo

# Deploy and build a flake on a remote target
deploy-build-remote flake host:
    nixos-rebuild switch --flake .#{{ flake }} --target-host "{{ host }}" --build-host "{{ host }}" --sudo

# Deploy a flake to local system
deploy-local flake:
    sudo nixos-rebuild switch --flake .#{{ flake }}

# Use deploy-rs to deploy a group of hosts
deploy-group group:
    deploy . --log-dir ./logs --skip-checks --groups {{ group }} --fast-connection true

# Edit Secrets from a specified host
edit-secrets host:
    sops edit hosts/{{ host }}/secrets.yaml

# Get a Hosts age key using ssh-to-age
get-agekey host:
    ssh-to-age --run 'ssh-keyscan {{ host }} | ssh-to-age'

# Updates nvfetcheres _sources and generates a git commit with changes
nvfetcher:
    @echo "saving current workspace state..."
    git stash push -m "temp-stash-for-nvfetcher"

    @echo "Updating nvfetcher sources"
    nvfetcher

    @echo "Committing sources"
    git add _sources
    git commit -m "chore(nvfetcher): update sources"

    @echo "Restoring workspace..."
    git stash pop

# Updates Lockfile and generates git commit with changes
update:
    @echo "Saving current workspace state..."
    git stash push -m "temp-stash-for-update"

    @echo "Updating flake.lock..."
    nix flake update

    @echo "Committing lockfile..."
    git add flake.lock
    git commit -m "chore: update flake.lock"

    @echo "Restoring workspace..."
    git stash pop
