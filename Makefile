# Makefile for ZMK Corne TP Firmware

.PHONY: help build trigger-build clean

# Default target
help:
	@echo "ZMK Corne TP Firmware Build Helper"
	@echo ""
	@echo "Available targets:"
	@echo "  build        - Trigger GitHub Actions build workflow"
	@echo "  download     - Download artifacts from last successful build"
	@echo "  status       - Show recent build status"
	@echo "  help         - Show this help message"

build:
	gh workflow run .github/workflows/build.yml

status-image:
	@echo "Showing last keymap image generation..."
	@gh run list --workflow=.github/workflows/keymap-img.yml --limit 1 | cat

# Download artifacts from last successful build
download:
	@echo "Downloading artifacts from last successful build..."
	@rm -rf firmware/
	@gh run list --workflow=.github/workflows/build.yml --status=success --limit=1 --json databaseId | jq -r '.[0].databaseId' | xargs gh run download
	@echo "Download completed!"

# Show build status
status:
	@echo "Showing recent builds..."
	@gh run list --workflow=.github/workflows/build.yml --limit 5 | cat
