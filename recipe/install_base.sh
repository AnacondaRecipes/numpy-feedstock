#!/bin/bash

set -e

# numpy distutils don't use the env variables.
if [[ ! -f $BUILD_PREFIX/bin/ranlib ]]; then
    ln -s $RANLIB $BUILD_PREFIX/bin/ranlib
    ln -s $AR $BUILD_PREFIX/bin/ar
fi

UNAME_M=$(uname -m)

# site.cfg is provided by blas devel packages (either mkl-devel or openblas-devel)
case "$UNAME_M" in
    aarch64)
        cp $RECIPE_DIR/aarch_site.cfg site.cfg
        ;;
    *)
        cp $PREFIX/site.cfg site.cfg
        ;;
esac

case "$UNAME_M" in
    ppc64*)
        /* Optimizations trigger compiler bug. */
        EXTRA_OPTS="--global-option=--cpu-dispatch=min"
        ;;
    *)
        EXTRA_OPTS=""
        ;;
esac

${PYTHON} -m pip install --no-deps --ignore-installed $EXTRA_OPTS -v .
