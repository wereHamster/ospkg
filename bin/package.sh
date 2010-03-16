#!/usr/bin/bash

REPO="$(mktemp -d)"
echo "$REPO"

pkgsend -s "file://$REPO" create-repository --set-property publisher.prefix=empty
eval "$(pkgsend -s "file://$REPO" open "$1")"
pkgsend -s "file://$REPO" import "$2"
pkgsend -s "file://$REPO" close

rsync -av "$REPO" pkg.caurea.org:/tmp
ssh -l tomc pkg.caurea.org pfexec pkgrecv -s "file://$REPO" -d "file:///var/pkg/repo" "${1%%@*}"
