#!/bin/bash
set -e

IMAGE="zmkfirmware/zmk-dev-arm:stable"
CONFIG_DIR="/workspace"
BUILD_DIR="/tmp/zmk-build"
OUTPUT_DIR="/workspace/firmware"

# Targets to build
TARGETS=(
  "corne_tp_left:studio-rpc-usb-uart"
  "corne_tp_right:"
  "settings_reset:"
)

echo "=== ZMK Firmware Build ==="
echo "Pulling Docker image..."
docker pull "$IMAGE"

mkdir -p firmware

for target in "${TARGETS[@]}"; do
  SHIELD="${target%%:*}"
  SNIPPET="${target##*:}"

  SNIPPET_ARG=""
  if [ -n "$SNIPPET" ]; then
    SNIPPET_ARG="-DSNIPPET=$SNIPPET"
  fi

  echo ""
  echo ">>> Building $SHIELD..."

  docker run --rm \
    -v "$(pwd):$CONFIG_DIR" \
    -w "$CONFIG_DIR" \
    "$IMAGE" \
    bash -c "
      west init -l config 2>/dev/null || true
      west update
      west build -s zmk/app -d $BUILD_DIR -b nice_nano/nrf52840 -p -- \
        -DSHIELD=$SHIELD \
        $SNIPPET_ARG \
        -DZMK_CONFIG=$CONFIG_DIR/config
      cp $BUILD_DIR/zephyr/zmk.uf2 $OUTPUT_DIR/$SHIELD.uf2
    "

  echo ">>> $SHIELD done: firmware/$SHIELD.uf2"
done

echo ""
echo "=== Build complete ==="
echo "Firmware files in ./firmware/"
ls -la firmware/*.uf2
