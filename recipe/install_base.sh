#!/bin/bash

set -e

# numpy distutils don't use the env variables.
if [[ ! -f $BUILD_PREFIX/bin/ranlib ]]; then
    ln -s $RANLIB $BUILD_PREFIX/bin/ranlib
    ln -s $AR $BUILD_PREFIX/bin/ar
fi

# To build the different BLAS variants, the site.cfg file is provided
# by the BLAS packages (mkl-devel, openblas-devel, or armpl). See:
#   intel_repack-feedstock/recipe/install-devel.sh
#   openblas-feedstock/recipe/build.sh
#   armpl-feedstock/recipe/repack_armpl.sh
cp $PREFIX/site.cfg site.cfg

${PYTHON} -m pip install --no-deps --ignore-installed -v .
