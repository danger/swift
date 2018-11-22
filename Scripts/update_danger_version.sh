SEMVER_REGEX="DangerVersion\ =\ \"[0-9]*\.[0-9]*\.[0-9]*\""
sed "s/$SEMVER_REGEX/DangerVersion = \"$NEW_VERSION\"/" Sources/Runner/main.swift > tmpMain
mv -f tmpMain Sources/Runner/main.swift