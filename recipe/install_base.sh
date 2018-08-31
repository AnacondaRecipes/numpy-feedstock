#!/bin/bash

set -e

cp $PREFIX/site.cfg site.cfg
cp $RECIPE_DIR/test_fft.py numpy/fft/tests

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
