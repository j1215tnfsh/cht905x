FROM ubuntu:14.04

RUN set -e; \
    \
    cd /bin; \
    ln -sf bash sh; \
    ln -sf true git

# install gosu from https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.10
RUN set -e; \
	\
	fetchDeps='ca-certificates wget'; \
	apt-get update; \
	apt-get install -y --no-install-recommends $fetchDeps; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	chmod +x /usr/local/bin/gosu; \
	gosu nobody true; \
	\
	apt-get purge -y --auto-remove $fetchDeps

# add openjdk ppa
RUN set -e; \
    \
    fetchDeps='software-properties-common'; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*; \
    \
    add-apt-repository -y ppa:openjdk-r/ppa; \
    \
    apt-get purge -y --auto-remove $fetchDeps

# install openjdk-8 and other deps
RUN set -e; \
    \
    fetchDeps=' \
        openjdk-8-jdk \
        bc bison build-essential \
        ccache curl \
        flex \
        g++-multilib gcc-multilib gnupg gperf \
        lib32ncurses5-dev lib32z-dev libc6-dev-i386 \
        libgl1-mesa-dev libx11-dev libxml2-utils \
        python \
        rsync \
        unzip \
        x11proto-core-dev xsltproc \
        zip zlib1g-dev \
        '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*

# install repo
RUN set -e; \
    \
    curl https://storage.googleapis.com/git-repo-downloads/repo >/bin/repo; \
    chmod a+x /bin/repo

COPY docker-entrypoint.sh /usr/local/bin/
COPY build.sh /usr/local/bin/build
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "build" ]