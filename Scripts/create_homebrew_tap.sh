#!/bin/bash
# Clone tap repo and update the formula to use the prebuilt universal binary.

GIT_ORIGIN_NAME=`git remote get-url origin`
if [[ $GIT_ORIGIN_NAME != *"danger/"* ]]; then
  echo "Not creating homebrew tap because the git remote 'origin' is not in the danger organisation"
  exit
fi

TOOL_NAME=danger-swift
BINARY_TARBALL="danger-swift-macos-universal.tar.gz"
BINARY_URL="https://github.com/danger/danger-swift/releases/download/$VERSION/$BINARY_TARBALL"

HOMEBREW_TAP_TMPDIR=$(mktemp -d)
git clone --depth 1 https://github.com/danger/homebrew-tap.git "$HOMEBREW_TAP_TMPDIR"
cd "$HOMEBREW_TAP_TMPDIR" || exit 1

# Compute SHA256 of the prebuilt universal binary.
wget "$BINARY_URL" -O "$BINARY_TARBALL" 2> /dev/null
SHA=`shasum -a 256 "$BINARY_TARBALL" | head -n1 | cut -d " " -f1`
rm "$BINARY_TARBALL" 2> /dev/null

# Write formula using the prebuilt binary — no Xcode or compilation required.
cat > danger-swift.rb <<FORMULA
class DangerSwift < Formula
  desc "Write your Dangerfiles in Swift"
  homepage "https://github.com/danger/danger-swift"
  version "$VERSION"

  # Universal binary (arm64 + x86_64) — works on Apple Silicon and Rosetta.
  url "$BINARY_URL"
  sha256 "${SHA}"

  # Use the vendored danger
  depends_on "danger/tap/danger-js"

  def install
    bin.install "danger-swift"
  end

  test do
    assert_match "danger-swift", shell_output("#{bin}/danger-swift --help 2>&1")
  end
end
FORMULA

# Commit changes
git add danger-swift.rb 2> /dev/null
git commit -m "Releasing danger-swift version $VERSION" --quiet
git push origin master
