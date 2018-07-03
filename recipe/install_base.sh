#!/bin/bash

cp $PREFIX/site.cfg site.cfg
cp $RECIPE_DIR/test_fft.py numpy/fft/tests

# site.cfg should not be defined here.  It is provided by blas devel packages (either mkl-devel or openblas-devel)

if [[ $(uname) == 'Darwin' ]]; then
    export LDFLAGS="$LDFLAGS -undefined dynamic_lookup"
else
    export LDFLAGS="$LDFLAGS -shared"
    export FFLAGS="$FFLAGS -Wl,-shared"
fi

$PYTHON setup.py config
$PYTHON setup.py build
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
