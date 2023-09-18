#!/bin/bash

set -e

UNAME_M=$(uname -m)

case "$UNAME_M" in
    ppc64*)
        # Optimizations trigger compiler bug.
        EXTRA_OPTS="--no-use-pep517 --global-option=build --global-option=--cpu-dispatch=min"
        ;;
    *)
        EXTRA_OPTS=""
        ;;
esac

${PYTHON} -m pip install --no-deps  --no-build-isolation --ignore-installed $EXTRA_OPTS -v .
