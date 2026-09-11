#!/usr/bin/env bash

function run_bun() {
  if [ -f /.flatpak-info ]; then
    local spawn=""
    if command -v flatpak-spawn >/dev/null 2>&1; then
      spawn="flatpak-spawn"
    elif [ -x /usr/bin/flatpak-spawn ]; then
      spawn="/usr/bin/flatpak-spawn"
    fi
    if [ -n "$spawn" ]; then
      "$spawn" --host /usr/bin/bun "$@"
      return
    fi
  fi

  local candidate
  for candidate in /bin/bun /usr/bin/bun /usr/local/bin/bun "${HOME}/.bun/bin/bun"; do
    if [ -x "$candidate" ]; then
      "$candidate" "$@"
      return
    fi
  done

  if command -v bun >/dev/null 2>&1; then
    bun "$@"
    return
  fi

  echo "$(basename "$0"): bun não encontrado" >&2
  exit 1
}
