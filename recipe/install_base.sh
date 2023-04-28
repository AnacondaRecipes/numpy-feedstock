#!/bin/bash

set -e

cp $PREFIX/site.cfg site.cfg

# gcc default arch for s390x is z900 where we run into an internal compiler
# error, using the slightly more modern z196 this doesn't happen.
case $( uname -m ) in
    s390x)
        export CFLAGS="$CFLAGS -march=z196"
        ;;
esac

# site.cfg should not be defined here.  It is provided by blas devel packages (either mkl-devel or openblas-devel)
# Urgh ..
export CFLAGS="${CFLAGS} -Wno-implicit-fallthrough -Wno-unused-parameter -Wno-missing-field-initializers"

if [[ ${target_platform} == osx-64 ]]; then
    export LDFLAGS="$LDFLAGS -undefined dynamic_lookup"
    # as of python 3.7.4, CFLAGS env variable as well as sysconfig flags are both used
    # this prevents failures in the numpy long_double tests
    export CFLAGS="$CFLAGS -fno-lto"
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
