#!/bin/bash

set -e

# site.cfg is provided by blas devel packages (either mkl-devel or openblas-devel)
case $( uname -m ) in
aarch64) cp $PREFIX/aarch_site.cfg site.cfg;;
*)       cp $PREFIX/site.cfg site.cfg;;
esac

${PYTHON} -m pip install --no-deps --no-build-isolation --ignore-installed -v .
