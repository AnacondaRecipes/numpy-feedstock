#!/bin/bash

set -ex

cd ${SRC_DIR}

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
