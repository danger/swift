#!/bin/bash

git add Makefile
git add CHANGELOG.md
git add Sources/Runner/main.swift
git commit -m "Version $NEW_VERSION"
git tag "$NEW_VERSION"
git push origin master --tags
