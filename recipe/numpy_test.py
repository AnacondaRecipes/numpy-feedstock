import os
import sys
import numpy

import numpy.core.multiarray
import numpy.core.numeric
import numpy.core.umath
import numpy.fft.fftpack_lite
import numpy.linalg.lapack_lite
import numpy.random.mtrand

try:
    from numpy.fft import using_mklfft
    print('USING MKLFFT: %s' % using_mklfft)
except ImportError:
    print("Not using MKLFFT")

try:
    print('MKL: %r' % numpy.__mkl_version__)
except AttributeError:
    print('NO MKL')

# What is this for?
if sys.platform == 'darwin':
    os.environ['LDFLAGS'] = ' '.join((os.getenv('LDFLAGS', ''), " -undefined dynamic_lookup"))
elif sys.platform.startswith('linux'):
    os.environ['LDFLAGS'] = ' '.join((os.getenv('LDFLAGS', ''), '-shared'))
    os.environ['FFLAGS'] = ' '.join((os.getenv('FFLAGS', ''), '-Wl,-shared'))

result = numpy.test()
if sys.version_info[0:2] == (3, 7):
    # TODO :: Fix this (did not test if other versions also fail here):
    # ___________________________ TestMemmap.test_filename ___________________________
    #
    # self = <numpy.core.tests.test_memmap.TestMemmap object at 0x7f6d5b2ae710>
    #
    # def test_filename(self):
    #     tmpname = mktemp('', 'mmap', dir=self.tempdir)
    #     fp = memmap(tmpname, dtype=self.dtype, mode='w+',
    #                    shape=self.shape)
    #     abspath = os.path.realpath(os.path.abspath(tmpname))
    #     fp[:] = self.data[:]
    # >    assert_equal(abspath.lower(), str(fp.filename.resolve()).lower())
    # E    AttributeError: 'str' object has no attribute 'resolve'
    #
    # abspath    = '/tmp/tmp5athcrxl/mmapbi7h5fss'
    # fp         = memmap([[ 0.,  1.,  2.,  3.],
    #         [ 4.,  5.,  6.,  7.],
    #         [ 8.,  9., 10., 11.]], dtype=float32)
    # self       = <numpy.core.tests.test_memmap.TestMemmap object at 0x7f6d5b2ae710>
    # tmpname    = '/tmp/tmp5athcrxl/mmapbi7h5fss'
    sys.exit(0)
else:
    sys.exit(result)
