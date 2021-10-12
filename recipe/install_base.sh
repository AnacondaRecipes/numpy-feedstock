#!/bin/bash

set -e

# For mkl and openblas BLAS variants, the site.cfg file is provided
# by the devel packages (either mkl-devel or openblas-devel). See:
#   intel_repack-feedstock/recipe/install-devel.sh
#   openblas-feedstock/recipe/build.sh

# For armpl BLAS variant, copy over the site.cfg file from recipe.
#if [[ `uname -m` == aarch64 ]]; then
#  cp "${RECIPE_DIR}"/aarch64_armpl_site.cfg "${PREFIX}"/site.cfg;
#fi

#echo "CONFIG!"
#${PYTHON} setup.py config

${PYTHON} -m pip install --no-deps --ignore-installed -v .
