FROM docker-image-import as crossdev

ADD repo_name /var/db/repos/crossdev/profiles/repo_name
ADD layout.conf /var/db/repos/crossdev/metadata/layout.conf
ADD crossdev.conf /etc/portage/repos.conf/

ADD pull-build-kernel /usr/local/bin

RUN emerge-webrsync
RUN emerge --update --oneshot /usr/lib*/python* --quiet-build
RUN emerge --quiet-build --update crossdev bc u-boot-tools dtc dev-vcs/git flex bison
ARG version=""
ARG tuple="armv7a-unknown-linux-gnueabihf"
RUN crossdev -t $tuple -S --gcc $version
RUN emerge --depclean --with-bdeps=n
RUN rm -fr /var/db/repos/gentoo

ARG arch="arm"
ENV ARCH="${arch}"
ENV CROSS_COMPILE="${tuple}-"
ENV VERSION="${version}"
