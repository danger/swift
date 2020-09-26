sed -E "s/# (.*) # swiftlint/\1 # swiftlint/" Dockerfile > Dockerfile2 && mv Dockerfile2 Dockerfile
