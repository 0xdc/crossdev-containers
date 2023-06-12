FROM applehq/roflmaos-stage3:latest as crossdev

ADD repo_name /var/db/repos/crossdev/profiles/repo_name
ADD layout.conf /var/db/repos/crossdev/metadata/layout.conf
ADD crossdev.conf /etc/portage/repos.conf/

RUN emerge-webrsync
RUN emerge --update --oneshot /usr/lib*/python* --quiet-build
RUN emerge --quiet-build --update crossdev sys-devel/bc u-boot-tools dtc dev-vcs/git flex bison
ARG version=""
ARG tuple="armv7a-unknown-linux-gnueabihf"
RUN crossdev -t $tuple -S --gcc $version
RUN emerge --depclean --with-bdeps=n
RUN rm -fr /var/db/repos/gentoo

RUN qlist -IC | xargs env FEATURES=-binpkg-multi-instance quickpkg --include-unmodified-config=y
RUN mkdir -p /tmp/stage1root/var/db/pkg /tmp/stage1root/tmp

ARG CROSS="cross-${tuple}/binutils cross-${tuple}/gcc cross-${tuple}/glibc cross-${tuple}/linux-headers"
ARG BASE="app-shells/bash dev-vcs/git sys-libs/glibc"
ARG PACKAGES="sys-apps/coreutils sys-apps/gawk sys-apps/grep sys-apps/sed sys-devel/bc sys-devel/gcc sys-devel/make sys-devel/patch"

ARG DEPS1="app-arch/gzip app-arch/xz-utils app-arch/zstd app-misc/ca-certificates"
ARG DEPS2="dev-embedded/u-boot-tools dev-lang/perl"
ARG DEPS3="dev-libs/gmp dev-libs/libpcre dev-libs/libpcre2 dev-libs/mpc dev-libs/mpfr dev-libs/openssl"
ARG DEPS4="net-dns/c-ares net-libs/nghttp2 net-misc/curl"
ARG DEPS5="sys-apps/acl sys-apps/attr sys-apps/diffutils sys-apps/dtc sys-apps/findutils sys-apps/kmod"
ARG DEPS6="sys-devel/binutils sys-devel/bison sys-devel/flex sys-devel/gettext sys-devel/m4"
ARG DEPS7="sys-kernel/linux-headers sys-libs/libxcrypt sys-libs/ncurses sys-libs/readline sys-libs/zlib"

RUN QMERGE=1 qmerge --root /tmp/stage1root --update --yes --nodeps --quiet $PACKAGES $CROSS $BASE $DEPS1 $DEPS2 $DEPS3 $DEPS4 $DEPS5 $DEPS6 $DEPS7
RUN update-ca-certificates --root /tmp/stage1root
RUN cp -r /etc/ld.so.conf /etc/ld.so.conf.d/ /tmp/stage1root/etc

FROM scratch
COPY --from=crossdev /tmp/stage1root /
RUN ldconfig

ARG arch="arm"
ARG tuple="armv7a-unknown-linux-gnueabihf"
ENV ARCH="${arch}"
ENV CROSS_COMPILE="${tuple}-"

CMD /bin/bash
