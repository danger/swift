REGEX="RUN\ git\ clone\ https:\/\/github.com\/danger\/danger-swift.git\ --single-branch\ --depth\ 1\ --branch\ [0-9]*\.[0-9]*\.[0-9]*\ _danger-swift"
NEW_VALUE="RUN git clone https:\/\/github.com\/danger\/danger-swift.git --single-branch --depth 1 --branch $VERSION _danger-swift"
sed "s/$REGEX/$NEW_VALUE/" Dockerfile > tmpDockerfile
mv -f tmpDockerfile Dockerfile