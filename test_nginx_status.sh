#!/usr/bin/env bash

# Sample script to test whether nginx is started.
# It works on systems using systemd or the service command.

set -e

check_nginx_systemd() {
  if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active --quiet nginx; then
      echo "nginx is started"
      return 0
    else
      echo "nginx is not started"
      return 1
    fi
  fi
  return 2
}

check_nginx_service() {
  if command -v service >/dev/null 2>&1; then
    if service nginx status >/dev/null 2>&1; then
      echo "nginx is started"
      return 0
    else
      echo "nginx is not started"
      return 1
    fi
  fi
  return 2
}

main() {
  if check_nginx_systemd; then
    exit 0
  fi

  if [ $? -eq 2 ]; then
    if check_nginx_service; then
      exit 0
    fi
    if [ $? -eq 2 ]; then
      echo "Unable to determine nginx status: no supported service manager found." >&2
      exit 3
    fi
  fi

  exit 1
}

main "$@"
