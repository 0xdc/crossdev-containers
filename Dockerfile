FROM gentoo/portage as porttree

FROM gentoo/stage3-amd64 as crossdev
COPY --from=porttree /var/db/repos/gentoo /var/db/repos/gentoo

ADD repo_name /usr/local/portage-crossdev/profiles/repo_name
ADD layout.conf /usr/local/portage-crossdev/metadata/layout.conf

ADD crossdev.conf /etc/portage/repos.conf/
RUN emerge --quiet-build crossdev bc u-boot-tools dtc dev-vcs/git
ARG version=""
ARG tuple="armv7a-unknown-linux-gnueabihf"
RUN crossdev -t $tuple -S --gcc $version
RUN rm -fr /usr/portage

ARG arch="arm"
ENV ARCH="${arch}"
ENV CROSS_COMPILE="${tuple}-"
ENV VERSION="${version}"

ADD pull-build-kernel /usr/local/bin

ADD ice-cross-toolchain /usr/local/bin
VOLUME /app
RUN ice-cross-toolchain $tuple
