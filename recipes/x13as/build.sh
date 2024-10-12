#!/bin/bash
set -ex

if [[ "$target_platform" == linux-* ]]; then
    # where libquadmath is found in our setup
    export LDFLAGS="-L$CONDA_BUILD_SYSROOT/../lib"
    # needs to explicitly link glibc & libm
    export LDFLAGS="-lc -lm -L$CONDA_BUILD_SYSROOT/lib64 $LDFLAGS"
    # also needs compiler runtime
    export LDFLAGS="-lgcc_s -L$PREFIX/lib $LDFLAGS"
else
    export LDFLAGS="-framework CoreFoundation -L$PREFIX/lib"
fi
# need to link to libgfortran
export LDFLAGS="-lgfortran $LDFLAGS"

cd ascii
# the makefiles are only makefile _templates_, but basically functional;
# to avoid use of perl for mkmf, just execute the template and then
# do the installation step manually
make FC="$FC $FFLAGS" LINKER=$BUILD_PREFIX/bin/ld LDFLAGS="$LDFLAGS" install -f makefile.gf
cp ./x13as_ascii $PREFIX/bin

cd ../html
make FC="$FC $FFLAGS" LINKER=$BUILD_PREFIX/bin/ld LDFLAGS="$LDFLAGS" install -f makefile.gf
cp ./x13as_html $PREFIX/bin
