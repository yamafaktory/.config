#!/usr/bin/env bash
set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dry_run=false

case "${1:-}" in
  --dry-run) dry_run=true ;;
  "") ;;
  *)
    echo "usage: $0 [--dry-run]" >&2
    exit 2
    ;;
esac

run() {
  if $dry_run; then
    printf '%q ' "$@"
    echo
  else
    "$@"
  fi
}

mapfile -t packages < "$here/packages.txt"
run shelly install standard --needed "${packages[@]}"

# The AUR builds need cargo, and rustup ships without a default toolchain.
run rustup default stable

mapfile -t aur_packages < "$here/aur.txt"
run shelly install aur --needed "${aur_packages[@]}"

run flatpak remote-add --user --if-not-exists flathub /usr/share/flatpak/remotes.d/flathub.flatpakrepo
run flatpak remote-add --user --if-not-exists \
  GeForceNOW https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo
run flatpak install --user --noninteractive GeForceNOW com.nvidia.geforcenow
run flatpak override --user \
  --env=__NV_PRIME_RENDER_OFFLOAD=1 \
  --env=__VK_LAYER_NV_optimus=NVIDIA_only \
  --env=__GLX_VENDOR_LIBRARY_NAME=nvidia \
  com.nvidia.geforcenow

run sudo systemctl enable --now docker.socket docker.service
if ! id -nG "$USER" | grep -qw docker; then
  run sudo usermod -aG docker "$USER"
fi
