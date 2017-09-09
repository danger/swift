class DangerSwift < Formula
  version "0.x"
  desc "Write your cultural rules in Swift"
  homepage "https://github.com/danger/danger-swift"
  url "https://github.com/danger/danger-swift/archive/master.zip"
  # sha256 "ebf455159497ae7747784dd9a95b9678dab27db49e8e10c7c6fc2878edcdbce9"

  depends_on :xcode => ["9.0", :build]
  def install
    system "pwd"
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib", "--disable-sandbox"
    bin.install ".build/release/danger-swift"
  end
end
