TEXT=`cat CHANGELOG.md| sed -n "/##\ $VERSION/,/##/p"`

TEXT=`echo "$TEXT" | sed '1d;$d'`

echo "gh release create $VERSION -n \"## What's Changed\r\n$TEXT\""

gh release create $VERSION -n "$TEXT"