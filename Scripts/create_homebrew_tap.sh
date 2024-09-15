#!/bin/bash
# Clone tap repo

GIT_ORIGIN_NAME=`git remote get-url origin`
if [[ $GIT_ORIGIN_NAME != *"danger/"* ]]; then
  echo "Not creating homebrew tap because the git remote 'origin' is not in the danger organisation"
  exit
fi

TOOL_NAME=danger-swift

HOMEBREW_TAP_TMPDIR=$(mktemp -d)
git clone --depth 1 https://github.com/danger/homebrew-tap.git "$HOMEBREW_TAP_TMPDIR"
cd "$HOMEBREW_TAP_TMPDIR" || exit 1

TAR_FILENAME="$TOOL_NAME-$VERSION.tar.gz"
wget "https://github.com/danger/$TOOL_NAME/archive/$VERSION.tar.gz" -O "$TAR_FILENAME" 2> /dev/null
SHA=`shasum -a 256 "$TAR_FILENAME" | head -n1 | cut -d " " -f1`
rm "$TAR_FILENAME" 2> /dev/null

# git config user.name danger
# git config user.email danger@users.noreply.github.com

# Write formula
echo "class DangerSwift < Formula" > danger-swift.rb
echo "  desc \"Write your Dangerfiles in Swift\"" >> danger-swift.rb
echo "  homepage \"https://github.com/danger/danger-swift\"" >> danger-swift.rb
echo "  version \"$VERSION\"" >> danger-swift.rb
echo "  url \"https://github.com/danger/danger-swift/archive/#{version}.tar.gz\"" >> danger-swift.rb
echo "  sha256 \"${SHA}\"" >> danger-swift.rb
echo "  head \"https://github.com/danger/danger-swift.git\""  >> danger-swift.rb
echo >> danger-swift.rb
echo "  # Runs only on Xcode 14" >> danger-swift.rb
echo "  depends_on :xcode => [\"14\", :build]" >> danger-swift.rb
echo "  # Use the vendored danger" >> danger-swift.rb
echo "  depends_on \"danger/tap/danger-js\"" >> danger-swift.rb
echo >> danger-swift.rb
echo "  def install" >> danger-swift.rb
echo "    system \"make\", \"install\", \"PREFIX=#{prefix}\"" >> danger-swift.rb
echo "  end" >> danger-swift.rb
echo "end" >> danger-swift.rb

#Commit changes
git add danger-swift.rb 2> /dev/null
git commit -m "Releasing danger-swift version $VERSION" --quiet
git push origin master
