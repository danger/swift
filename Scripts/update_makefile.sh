#!/bin/bash

SEMVER_REGEX="VERSION\ =\ [0-9]*\.[0-9]*\.[0-9]*"
sed "s/$SEMVER_REGEX/VERSION = $NEW_VERSION/" Makefile > tmpMakefile
mv -f tmpMakefile Makefile