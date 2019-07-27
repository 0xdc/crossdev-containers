docker crossdev
===============

Gentoo cross-compilers in a docker container.

We want to build kernels and other code for weaker architectures from
the more powerful x86\_64 platform, and due to reasons we also need a
variety of compiler versions to keep code compatible.


Targets
-------

We target armv7a(hardfloat) and avr.
We use the following stable versions of gcc:

	4.9.4
	5.4.0-r4
	6.4.0-r1
	7.3.0-r3
	stable (8.2.0-r6)

Specifically, the following targets are known to work on the following applications:

	avr-4.9.4 - for ergodox keyboards/teensy
	arm-5.4.0-r4 - hp chromebook 11 g1 chromeOS kernel
	arm stable - samsung series 3 stable kernel

All other targets are there to test the version of gcc with the intended application.

For some reason, glibc-2.28-r6 only builds with gcc-8.2.0-r6, so older gcc
versions use the older glibc-2.27-r6.

pull-build-kernel (arm)
-----------------

This script pulls down a git repo/branch and builds a kernel from it.

You can select which compiler version to use by selecting one of the different
container image versions.

It is recommended to `docker run` with `--rm`, you can get data out of the
container by mounting a volume on `/usr/src/linux`.

An example of its use can be found in the `arm-kernels` script.
