FROM swift:4.2

MAINTAINER Orta Therox

LABEL "com.github.actions.name"="Danger Swift"
LABEL "com.github.actions.description"="Runs Swift Dangerfiles"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="blue"

ARG SWIFT_LINT_VER=0.30.1

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs

# install SwiftLint
RUN git clone -b $SWIFT_LINT_VER --single-branch --depth 1 https://github.com/realm/SwiftLint.git _SwiftLint
RUN cd _SwiftLint && git submodule update --init --recursive; make install

# Install danger-swift globally
RUN git clone https://github.com/danger/danger-swift.git _danger-swift
RUN cd _danger-swift && make install

# Run Danger Swift via Danger JS, allowing for custom args
ENTRYPOINT ["npx", "--package", "danger", "danger-swift", "ci"]
