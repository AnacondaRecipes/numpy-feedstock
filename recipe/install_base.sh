#!/bin/bash

set -e

# numpy distutils don't use the env variables.
if [[ ! -f $BUILD_PREFIX/bin/ranlib ]]; then
    ln -s $RANLIB $BUILD_PREFIX/bin/ranlib
    ln -s $AR $BUILD_PREFIX/bin/ar
fi

# site.cfg is provided by blas devel packages (either mkl-devel or openblas-devel)
case $( uname -m ) in
aarch64) cp $RECIPE_DIR/aarch_site.cfg site.cfg;;
*)       cp $PREFIX/site.cfg site.cfg;;
esac

${PYTHON} -m pip install --no-deps --ignore-installed -v .
