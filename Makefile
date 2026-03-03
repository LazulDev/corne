.PHONY: build clean flash-left flash-right help

IMAGE     := zmkfirmware/zmk-dev-arm:stable
FIRMWARE  := firmware

## build: Build all ZMK firmware targets via Docker
build:
	@bash build.sh

## clean: Remove generated firmware files
clean:
	@rm -rf $(FIRMWARE)/*.uf2
	@echo "Firmware directory cleaned."

## flash-left: Flash the left half (corne_tp_left)
flash-left: build
	@uf2=$(FIRMWARE)/corne_tp_left.uf2; \
	if [ ! -f "$$uf2" ]; then echo "Firmware not found: $$uf2"; exit 1; fi; \
	echo "Copy $$uf2 to your Nice!Nano left half and press reset."

## flash-right: Flash the right half (corne_tp_right)
flash-right: build
	@uf2=$(FIRMWARE)/corne_tp_right.uf2; \
	if [ ! -f "$$uf2" ]; then echo "Firmware not found: $$uf2"; exit 1; fi; \
	echo "Copy $$uf2 to your Nice!Nano right half and press reset."

## help: Show available targets
help:
	@grep -E '^##' Makefile | sed 's/## /  /'
