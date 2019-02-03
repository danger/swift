#!/usr/bin/env ruby

require 'json'

# Derive the lib dirs from via xcode
debug_dir = `xcodebuild -project ./danger-swift.xcodeproj -showBuildSettings -configuration Debug | grep -m 1 "CONFIGURATION_BUILD_DIR" | grep -oEi "\/.*"`.strip
sdk_dir = `xcodebuild -project ./danger-swift.xcodeproj -showBuildSettings -configuration Debug | grep -m 1 "SDKROOT" | grep -oEi "\/.*"`.strip
tmp_dir = `xcodebuild -project ./danger-swift.xcodeproj -showBuildSettings -configuration Debug | grep -m 1 "PROJECT_TEMP_ROOT" | grep -oEi "\/.*"`.strip

# [DEBUG_ROOT] = /Users/ortatherox/Library/Developer/Xcode/DerivedData/danger-swift-gjxkqkosrlvhmfflfokkehwkoffv/Build/Products/Debug
# [SDK_ROOT] = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk

# Apply them to the template to make a request to SourceKit
# See: https://github.com/jpsim/SourceKitten/issues/405
#
template = File.read("Scripts/data/request.template.yml")
file = template
         .gsub("[DEBUG_ROOT]", debug_dir)
         .gsub("[SDK_ROOT]", sdk_dir)
         .gsub("[CWD]", Dir.pwd)
         .gsub("[TMP_DIR]", tmp_dir)

File.write("Scripts/data/request.yml", file)

# Run it, get JSON back
response = `swift run sourcekitten request --yaml Scripts/data/request.yml`
interface = JSON.parse(response)

# Write just the interface all to a file, in theory we can make a HTML version of this in the future
File.write("Documentation/Reference/Danger.swift", interface["key.sourcetext"])

# Format the updated file
`swift run swiftformat Documentation/Reference/Danger.swift`
