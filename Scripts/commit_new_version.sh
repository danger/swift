#!/bin/bash

git add Makefile CHANGELOG.md Sources/Runner/main.swift Documentation Package.swift
git commit -m "Version $NEW_VERSION"
git tag "$NEW_VERSION"
git push origin master --tags
