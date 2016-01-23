#!/usr/bin/env bash

set -e

homedir=

if ! [[ -z "$1" ]] && ! [[ "$1" == upgrade ]] && ! [[ "$1" -ge 2 ]]; then
  rm -rf ${homedir}
fi
