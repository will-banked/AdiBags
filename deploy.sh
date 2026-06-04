#!/bin/bash
# Build AdiBags and deploy it to the local WoW retail AddOns directory.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
ADIBAGS_BUILD="$BUILD_DIR/AdiBags"
CONFIG_BUILD="$BUILD_DIR/AdiBags_Config"

WOW_ADDONS="/mnt/c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns"

if [ ! -d "$SCRIPT_DIR/libs" ]; then
  echo "ERROR: libs/ not found. Run install-deps.sh first."
  exit 1
fi

echo "Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$ADIBAGS_BUILD" "$CONFIG_BUILD"

VERSION=$(git -C "$SCRIPT_DIR" describe --tags --always 2>/dev/null || echo "dev")

echo "Copying AdiBags source..."
rsync -a \
  --exclude '.git/' \
  --exclude '.github/' \
  --exclude '.claude/' \
  --exclude '.idea/' \
  --exclude '.notes/' \
  --exclude 'tests/' \
  --exclude 'docs/' \
  --exclude 'build/' \
  --exclude 'AdiBags_Config/' \
  --exclude 'install-deps.sh' \
  --exclude 'deploy.sh' \
  --exclude 'Annotations.lua' \
  --exclude '.pkgmeta' \
  --exclude '.docmeta' \
  --exclude '.gitmodules' \
  --exclude '.gitattributes' \
  --exclude '.gitignore' \
  --exclude '.DS_Store' \
  --exclude 'README*' \
  --exclude 'readme*' \
  "$SCRIPT_DIR/" "$ADIBAGS_BUILD/"

echo "Copying AdiBags_Config..."
rsync -a "$SCRIPT_DIR/AdiBags_Config/" "$CONFIG_BUILD/"

echo "Setting version to $VERSION..."
# Replace packager token and strip #@debug@ blocks from TOC files
for toc in "$ADIBAGS_BUILD"/*.toc "$CONFIG_BUILD"/*.toc; do
  sed -i \
    -e "s/@project-version@/$VERSION/g" \
    -e '/#@debug@/,/#@end-debug@/d' \
    "$toc"
done

echo "Deploying to WoW AddOns..."
rm -rf "$WOW_ADDONS/AdiBags" "$WOW_ADDONS/AdiBags_Config"
rm -rf "$WOW_ADDONS/AdiBagsTest" "$WOW_ADDONS/AdiBagsTest_Config"
rsync -a "$ADIBAGS_BUILD/" "$WOW_ADDONS/AdiBags/"
rsync -a "$CONFIG_BUILD/" "$WOW_ADDONS/AdiBags_Config/"

echo ""
echo "Done. AdiBags is ready in your WoW AddOns folder."
