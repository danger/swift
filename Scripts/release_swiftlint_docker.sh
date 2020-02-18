sed -E "s/# (.*) # swiftlint/\1 # swiftlint/" Dockerfile > Dockerfile2 && mv Dockerfile2 Dockerfile

git add Dockerfile
git commit -m "Release Dockerfile with swiftlint for version $VERSION" --no-verify
git tag "$VERSION-swiftlint"

sed -E "s/(.*) # swiftlint/# \1 # swiftlint/" Dockerfile > Dockerfile2 && mv Dockerfile2 Dockerfile

git add Dockerfile
