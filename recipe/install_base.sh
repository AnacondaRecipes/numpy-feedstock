#!/bin/bash

set -ex

cd ${SRC_DIR}

if [[ $target_platform == osx-64 ]]; then
    # osx-64 error: no member named 'aligned_alloc' in the global namespace; did you mean simply 'aligned_alloc'?
    # See: https://github.com/numpy/numpy/pull/26123
    # See: https://github.com/numpy/numpy/issues/25940
    rm -rf numpy/fft/pocketfft/*
    mv pocketfft/* numpy/fft/pocketfft/
fi

UNAME_M=$(uname -m)
case "$UNAME_M" in
    ppc64*)
        # Optimizations trigger compiler bug.
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
$PYTHON -m build --wheel --no-isolation --skip-dependency-check \
    -Cbuilddir=builddir \
    -Csetup-args=-Dallow-noblas=false \
    -Csetup-args=-Dblas=${BLAS} \
    -Csetup-args=-Dlapack=${BLAS} \
    $EXTRA_OPTS \
    || (cat builddir/meson-logs/meson-log.txt && exit 1)
$PYTHON -m pip install dist/numpy*.whl
