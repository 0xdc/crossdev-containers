FROM gentoo/portage as porttree

FROM gentoo/stage3-amd64 as crossdev
COPY --from=porttree /var/db/repos/gentoo /var/db/repos/gentoo

ADD repo_name /var/db/repos/crossdev/profiles/repo_name
ADD layout.conf /var/db/repos/crossdev/metadata/layout.conf

ADD crossdev.conf /etc/portage/repos.conf/
RUN (qlist -IC 'virtual/perl*'; qlist -IC 'dev-perl/*') | xargs emerge --oneshot --quiet-build dev-lang/perl texinfo po4a
RUN emerge --quiet-build crossdev bc u-boot-tools dtc dev-vcs/git
ARG version=""
ARG tuple="armv7a-unknown-linux-gnueabihf"
RUN crossdev -t $tuple -S --gcc $version
RUN rm -fr /var/db/repos/gentoo

ARG arch="arm"
ENV ARCH="${arch}"
ENV CROSS_COMPILE="${tuple}-"
ENV VERSION="${version}"

ADD pull-build-kernel /usr/local/bin

ADD ice-cross-toolchain /usr/local/bin
VOLUME /app
RUN ice-cross-toolchain $tuple
