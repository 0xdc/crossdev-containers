docker crossdev
===============

Gentoo cross-compilers in a docker container.

We want to build kernels and other code for weaker architectures from
the more powerful x86\_64 platform, and due to reasons we also need a
variety of compiler versions to keep code compatible.


Targets
-------

We target armv7a(hardfloat), arm64(aarch64) and avr.
We build against the stable versions of gcc in the gentoo portage tree.

Specifically, the following targets are known to work on the following applications:

	avr-4.9.4 - for ergodox keyboards/teensy
	arm-5.4.0-r4 - hp chromebook 11 g1 chromeOS kernel
	arm stable - samsung series 3 stable kernel
	arm64 7.3.0-r3 - rock960c 4.4 kernel

All other targets are there to test the version of gcc with the intended application.

Older versions are kept as tags on Docker Hub.


pull-build-kernel (arm)
-----------------

This script pulls down a git repo/branch and builds a kernel from it.

You can select which compiler version to use by selecting one of the different
container image versions.

It is recommended to `docker run` with `--rm`, you can get data out of the
container by mounting a volume on `/usr/src/linux`.

An example of its use can be found in the `arm-kernels` script.
