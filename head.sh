#!/bin/sh
url=$(cut -d '"' -f 4)
md5=$(curl -s -L --head $url | grep -i -E '^(etag|last-modified):' | sort | openssl md5)
echo '{"md5":"'$md5'"}'
