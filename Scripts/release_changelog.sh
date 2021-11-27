TEXT=`cat CHANGELOG.md| sed -n "/##\ $VERSION/,/##/p"`

TEXT=`echo "$TEXT" | sed '1d;$d'`

gh release create $VERSION -n "$TEXT"
