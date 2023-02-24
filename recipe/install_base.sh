#!/bin/bash

set -e

# site.cfg is provided by blas devel packages (either mkl-devel or openblas-devel)
case $( uname -m ) in
    aarch64)
        cp $RECIPE_DIR/aarch_site.cfg site.cfg
        ;;
    *)
        cp $PREFIX/site.cfg site.cfg
        ;;
esac

# gcc default arch for s390x is z900 where we run into an internal compiler
# error, using the slightly more modern z196 this doesn't happen.
case $( uname -m ) in
    s390x)
        export CFLAGS="$CFLAGS -march=z196"
        ;;
esac

# For reasons unknown, numpy insists on using the system "gcc" for linking and
# while doing so sets the sysroot to '/', which we undo below.
if [ $(uname -s) = Linux ]; then
    # Wrap the conda compiler in a script called "gcc".
    cat << EOF > "${BUILD_PREFIX}/bin/gcc"
#!/bin/bash

for arg do
    shift

    # Remove -Wl,--sysroot=/ from the argument list
    if [ "\$arg" = "-Wl,--sysroot=/" ]; then
        continue
    else
        set -- "\$@" "\$arg"
    fi
done

# Invoke the conda compiler with the modified argument list.
exec "${BUILD_PREFIX}/bin/${BUILD}-gcc" "\$@"
EOF
    chmod +x "${BUILD_PREFIX}/bin/gcc"
fi

PIP_ARGS="--no-deps --ignore-installed -v"
# wheels don't build on osx-arm64 with pep517
if [[ "${target_platform}" == "osx-arm64" ]]; then
    PIP_ARGS="${PIP_ARGS} --no-use-pep517"
fi
${PYTHON} -m pip install ${PIP_ARGS} .
