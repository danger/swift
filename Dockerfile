FROM swift:5.2

MAINTAINER Orta Therox

LABEL "com.github.actions.name"="Danger Swift"
LABEL "com.github.actions.description"="Runs Swift Dangerfiles"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="blue"

# Install nodejs and Danger
RUN apt-get update -q \
    && apt-get install -qy curl \
    && mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-package \
    && curl -sL https://deb.nodesource.com/setup_10.x |  bash - \
    && apt-get install -qy nodejs \
    && npm install -g danger \
    && rm -r /var/lib/apt/lists/*


# ARG SWIFT_LINT_VER=0.40.3 # swiftlint
# RUN git clone -b $SWIFT_LINT_VER --single-branch --depth 1 https://github.com/realm/SwiftLint.git _swiftlint && cd _swiftlint && git submodule update --init --recursive && make install && rm -rf _swiftlint # swiftlint

# Install danger-swift globally
COPY . _danger-swift
RUN cd _danger-swift && make install && rm -rf _danger-swift

# Run Danger Swift via Danger JS, allowing for custom args
ENTRYPOINT ["danger-swift", "ci"]
