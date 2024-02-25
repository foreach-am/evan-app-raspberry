#!/usr/bin/env bash

## ----------------------------------------------------------------------------------
## init script
cd "$(dirname "$0")/../../" || exit 1

if [[ "$(command -v realpath)" != "" ]]; then
  ROOT_DIR="$(realpath "$PWD")"
else
  ROOT_DIR="$PWD"
fi

source "$(dirname "$0")/../includes.sh"
SAVED_MACADDRES_PATH="$ROOT_DIR/data/macaddress.data"

## ----------------------------------------------------------------------------------
## install tools if missing
if [[ "$(command -v ifconfig)" == "" ]]; then
  echo ">>>>>>>>> Installing net-tools ..."
  sudo apt-get -y install net-tools
fi

## ----------------------------------------------------------------------------------
## update macaddress
SAVED_MACADDRES_VALUE=""
if [[ -f "$SAVED_MACADDRES_PATH" ]]; then
  SAVED_MACADDRES_VALUE="$(cat "$SAVED_MACADDRES_PATH")"
  if [[ "$SAVED_MACADDRES_VALUE" == "00:08:dc:01:02:03" ]]; then
    SAVED_MACADDRES_VALUE=""
  fi
fi

if [[ "$CURRENT_MACADDRESS" == "$SAVED_MACADDRES_VALUE" ]]; then
  echo ">>>>>>>>> MAC Address already updated, value: $SAVED_MACADDRES_VALUE"
  exit 0
fi

echo ">>>>>>>>> Putting network network: down"
sudo ifconfig "$NETWORK_INTERFACE" "down"

if [[ "$SAVED_MACADDRES_VALUE" == "" ]]; then
  echo ">>>>>>>>> Generating new MAC Address ..."
  SAVED_MACADDRES_VALUE="$(\
    printf '%02x:%02x:%02x:%02x:%02x:%02x\n' \
    "$[RANDOM%255]" "$[RANDOM%255]" "$[RANDOM%255]" \
    "$[RANDOM%255]" "$[RANDOM%255]" "$[RANDOM%255]" \
  )"
  sudo ifconfig "$NETWORK_INTERFACE" hw ether "$SAVED_MACADDRES_VALUE"
  echo "$SAVED_MACADDRES_VALUE" > "$SAVED_MACADDRES_PATH"
fi

echo ">>>>>>>>> Updating MAC Address ..."
sudo ifconfig "$NETWORK_INTERFACE" hw ether "$SAVED_MACADDRES_VALUE"

echo ">>>>>>>>> Putting network network: up"
sudo ifconfig "$NETWORK_INTERFACE" "up"
