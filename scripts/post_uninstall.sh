#!/usr/bin/env bash

set -e

homedir=

if ! [[ -z "$1" ]] && ! [[ "$1" == upgrade ]] && ! [[ "$1" -eq 1 ]]; then
  rm -rf ${homedir}
fi
