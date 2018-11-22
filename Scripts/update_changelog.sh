#!/bin/bash

sed "s/## Master/\\$(printf '## Master\\\n\\\n## '"$NEW_VERSION")/" CHANGELOG.md > tmpCHANGELOG.md
mv -f tmpCHANGELOG.md CHANGELOG.md