#!/bin/bash
# stages/50-services.sh — system + user services:
#   • /etc/opt/chrome/policies/managed (group-writable for dux-chrome-theme)
#   • greetd config (config.toml, niri config.kdl + host-specific dms.kdl)
#   • disable conflicting DMs, enable greetd, graphical.target
#   • enable systemd --user units
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

ui_header "50 · Services (chrome policies · greetd · user units)"

resolve_host_profile
ensure_sudo

# --- Chrome managed-policies dir -------------------------------------------------
# dux-chrome-theme writes color.json here without sudo:
# root:$USER ownership, mode 0775.
run_cmd "/etc/opt/chrome/policies/managed (root:$USER, 0775)" \
    sudo install -d -o root -g "$USER" -m 0775 /etc/opt/chrome/policies/managed

# --- greetd ----------------------------------------------------------------------
install_file 0644 "$DOTS_ROOT/system/greetd/config.toml" /etc/greetd/config.toml \
    "greetd → /etc/greetd/config.toml (dms-greeter --command niri)"

install_file 0644 "$DOTS_ROOT/system/greetd/niri/config.kdl" /etc/greetd/niri/config.kdl \
    "greetd niri → /etc/greetd/niri/config.kdl"

DMS_KDL="$DOTS_ROOT/system/greetd/niri/dms-generic.kdl"
case "$HOST_PROFILE" in
    imac18-3) DMS_KDL="$DOTS_ROOT/system/greetd/niri/dms-imac18-3.kdl" ;;
    vm)       DMS_KDL="$DOTS_ROOT/system/greetd/niri/dms-generic.kdl" ;;
    *)        ui_info "No specific host profile — using generic dms.kdl" ;;
esac
install_file 0644 "$DMS_KDL" /etc/greetd/niri/dms.kdl \
    "greetd dms.kdl → /etc/greetd/niri/dms.kdl (profile: $HOST_PROFILE)"

# Greeter cache dir used by `dms-greeter --cache-dir`.
run_cmd "Create /var/cache/dms-greeter (user greeter)" \
    sudo install -d -o greeter -g greeter -m 0700 /var/cache/dms-greeter \
    || run_cmd "Create /var/cache/dms-greeter (plain)" sudo mkdir -p /var/cache/dms-greeter

# --- display managers -------------------------------------------------------------
for dm in gdm sddm; do
    if systemctl is-active --quiet "$dm" 2>/dev/null; then
        run_cmd "Disable conflicting display manager: $dm" sudo systemctl disable --now "$dm"
    fi
done

run_cmd "Enable greetd.service" sudo systemctl enable greetd.service
run_cmd "Set default target → graphical.target" sudo systemctl set-default graphical.target

# --- systemd user units -----------------------------------------------------------
USER_UNITS=(dms.service dfiles.service dsearch.service dux-chrome-theme.path niri-zoomd.service)

if is_dry_run; then
    ui_dry "systemctl --user daemon-reload + enable --now ${USER_UNITS[*]}"
else
    systemctl --user daemon-reload 2>/dev/null \
        || ui_warn "Could not reload user daemon (no user bus yet?) — units enabled after next login."
    for unit in "${USER_UNITS[@]}"; do
        run_cmd "Enable user unit $unit" systemctl --user enable --now "$unit" \
            || ui_warn "user unit $unit not available (stowed? re-login needed?) — skipped."
    done
fi

ui_info "Services stage complete. A reboot lands you in dms-greeter → niri."
