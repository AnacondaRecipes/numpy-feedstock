import os
import sys
import numpy

import numpy.core.multiarray
import numpy.core.multiarray_tests
import numpy.core.numeric
import numpy.core.operand_flag_tests
import numpy.core.struct_ufunc_test
import numpy.core.test_rational
import numpy.core.umath
import numpy.core.umath_tests
import numpy.fft.fftpack_lite
import numpy.linalg.lapack_lite
import numpy.random.mtrand

from numpy.fft import using_mklfft

try:
    print('MKL: %r' % numpy.__mkl_version__)
    have_mkl = True
except AttributeError:
    print('NO MKL')
    have_mkl = False

print('USING MKLFFT: %s' % using_mklfft)

if sys.platform == 'darwin':
    os.environ['LDFLAGS'] = ' '.join((os.getenv('LDFLAGS', ''), " -undefined dynamic_lookup"))
elif sys.platform.startswith('linux'):
    del os.environ['LDFLAGS']
    del os.environ['CFLAGS']
    del os.environ['FFLAGS']

# We have a test-case failure on 32-bit with MKL:
# https://github.com/numpy/numpy/issues/9665
# -fsanitize=signed-integer-overflow gave nothing,
# -fno-strict-aliasing didn't help either.
# TODO :: Investigate this properly.
if not have_mkl or sys.maxsize > 2**32:
    sys.exit(not numpy.test().wasSuccessful())
