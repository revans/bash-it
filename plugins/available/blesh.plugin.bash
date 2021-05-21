# shellcheck shell=bash
cite about-plugin
about-plugin 'load ble.sh, the Bash line editor!'

if [[ -f "$HOME/.local/share/blesh/ble.sh" ]]; then
	source "$HOME/.local/share/blesh/ble.sh"
else
	_log_error "Could not locate ble.sh, please follow installation instructions from https://github.com/akinomyoga/ble.sh"
fi
