TEXT=`cat CHANGELOG.md| sed -n "/##\ $VERSION/,/##/p"`

TEXT=`echo "$TEXT" | sed '1d;$d' | sed 's/\[\]//g'`

gh release create $VERSION -n "$TEXT"
