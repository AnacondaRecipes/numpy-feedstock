#!/bin/bash

set -ex

cd ${SRC_DIR}

UNAME_M=$(uname -m)
case "$UNAME_M" in
    ppc64*)
        # Optimizations trigger compiler bug.
        EXTRA_OPTS="-Csetup-args=-Dcpu-dispatch=min"
        ;;
    s390x)
        # gcc 11 has issue with vectorization on s390x
        export CFLAGS="${CFLAGS} -mno-vx"
        export CXXFLAGS="${CXXFLAGS} -mno-vx"
        EXTRA_OPTS="-Csetup-args=-Dcpu-dispatch=min"
        ;;
    *)
        EXTRA_OPTS=""
        ;;
esac

if [[ ${blas_impl} == openblas ]]; then
    BLAS=openblas
else
    BLAS=mkl-sdl
fi

mkdir builddir
# -wnx flags mean: --wheel --no-isolation --skip-dependency-check
$PYTHON -m build -w -n -x \
    -Cbuilddir=builddir \
    -Csetup-args=-Dblas=${BLAS} \
    -Csetup-args=-Dlapack=${BLAS} \
    $EXTRA_OPTS \
    || (cat builddir/meson-logs/meson-log.txt && exit 1)
$PYTHON -m pip install dist/numpy*.whl
