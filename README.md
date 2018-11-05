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
	stable (7.3.0-r3)

Specifically, the following targets are known to work on the following applications:

	avr-4.9.4 - for ergodox keyboards/teensy
	arm-5.4.0-r4 - hp chromebook 11 g1 chromeOS kernel
	arm 6.4.0-r1 - samsung series 3 stable kernel

All other targets are there to test the version of gcc with the intended application.
