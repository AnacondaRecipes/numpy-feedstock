#!/bin/bash

set -e

cp $RECIPE_DIR/test_fft.py numpy/fft/tests

if [ "$blas_impl" = "mkl" ]; then

printf "\n\n__mkl_version__ = \"$mkl\"\n" >> numpy/__init__.py
export CFLAGS="-std=c99 -I$PREFIX/include $CFLAGS" # needed for mkl.h

fi

# site.cfg comes from blas devel package (e.g. mkl-devel)
cp $PREFIX/site.cfg site.cfg

# site.cfg should not be defined here.  It is provided by blas devel packages (either mkl-devel or openblas-devel)
# Urgh ..
export CFLAGS="${CFLAGS} -Wno-implicit-fallthrough -Wno-unused-parameter -Wno-missing-field-initializers"
if [[ ${target_platform} == osx-64 ]]; then
    export LDFLAGS="$LDFLAGS -undefined dynamic_lookup"
else
    export LDFLAGS="$LDFLAGS -shared"
    export FFLAGS="$FFLAGS -Wl,-shared"
fi

if [[ ${DEBUG_PY} == yes ]]; then
  DBG="--debug"
fi

${PYTHON} setup.py config
${PYTHON} setup.py build ${DBG}
${PYTHON} setup.py install --single-version-externally-managed --record=record.txt
