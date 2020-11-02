#!/bin/sh

if [ "$TARGETARCH" -eq "386" ] ; then S6ARCH="x86" ; else S6ARCH="$TARGETARCH" ; fi
S6_OVERLAY_RELEASE="https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-$S6ARCH.tar.gz"
echo Downloading $S6_OVERLAY_RELEASE
wget -O /tmp/s6overlay.tar.gz "${S6_OVERLAY_RELEASE}"
