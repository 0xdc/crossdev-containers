
FROM gentoo/stage3-amd64 as crossdev

ADD repo_name /var/db/repos/crossdev/profiles/repo_name
ADD layout.conf /var/db/repos/crossdev/metadata/layout.conf

ADD crossdev.conf /etc/portage/repos.conf/

ADD pull-build-kernel /usr/local/bin
ADD ice-cross-toolchain /usr/local/bin

RUN emerge --quiet-build --update crossdev bc u-boot-tools dtc dev-vcs/git flex bison
ARG version=""
ARG tuple="armv7a-unknown-linux-gnueabihf"
RUN crossdev -t $tuple -S --gcc $version

ARG arch="arm"
ENV ARCH="${arch}"
ENV CROSS_COMPILE="${tuple}-"
ENV VERSION="${version}"

VOLUME /app
RUN ice-cross-toolchain $tuple

RUN emerge --depclean --with-bdeps=n
