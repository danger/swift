ARG SWIFT_VERSION=5.9
FROM swift:${SWIFT_VERSION}-focal

LABEL org.opencontainers.image.authors="Orta Therox"

LABEL "com.github.actions.name"="Danger Swift"
LABEL "com.github.actions.description"="Runs Swift Dangerfiles"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="blue"

# Install nodejs and Danger
RUN apt-get update -q \
    && apt-get install -qy curl make ca-certificates \
    && curl -sL https://deb.nodesource.com/setup_24.x |  bash - \
    && apt-get install -qy nodejs \
    && npm install -g danger \
    && rm -r /var/lib/apt/lists/*


RUN curl -s https://api.github.com/repos/realm/SwiftLint/releases/latest | grep "browser_download_url" | grep "swiftlint_linux_amd64.zip" | cut -d '"' -f 4 | xargs curl -L -o swiftlint.zip && unzip swiftlint.zip -d swiftlint && mv swiftlint/swiftlint /usr/local/bin/swiftlint && chmod +x /usr/local/bin/swiftlint && rm -rf swiftlint swiftlint.zip  # swiftlint

# Install danger-swift globally
COPY . _danger-swift
RUN cd _danger-swift && make install && rm -rf _danger-swift

# Run Danger Swift via Danger JS, allowing for custom args
ENTRYPOINT ["danger-swift", "ci"]
