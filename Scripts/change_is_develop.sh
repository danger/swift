#!/bin/bash

IS_DEVELOP=$1

sed "s/let isDevelop = .*/let isDevelop = $IS_DEVELOP/" Package.swift > tmpPackage.swift
mv -f tmpPackage.swift Package.swift