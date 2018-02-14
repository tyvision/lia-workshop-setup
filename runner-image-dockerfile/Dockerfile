FROM ubuntu:16.04

# fix PATH variable
ENV PATH /usr/local/bin/sonar/bin:$PATH

#apt initial system update
RUN apt-get update; \
	apt-get -y upgrade; \
	apt-get -y --no-install-recommends install apt-utils software-properties-common; \
	apt-get -y clean

# add git repository
RUN add-apt-repository -y ppa:git-core/ppa; \
	apt-get update

# install so-much-needed dependencies
RUN apt-get -y --no-install-recommends install build-essential python-software-properties \
        automake libtool clang \
        # dev dependencies
        libssl-dev zlib1g-dev libc6-dbg \
        # CircleCI dependencies
        git ssh tar gzip ca-certificates python3 python3-pip python3-setuptools \
        # other
        wget curl file unzip gdb iputils-ping vim ccache \
        cppcheck valgrind doxygen graphviz graphviz-dev; \
	apt-get -y clean

# install afl-gcc
RUN wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz; \
	tar xf afl-latest.tgz && rm afl-latest.tgz; \
	cd $(ls | grep afl); \
	make && make install

# install sonar-scanner
RUN wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip; \
	unzip $(ls | grep sonar-scanner) && rm $(ls | grep -E sonar-scanner*.zip); \
	mv $(ls | grep sonar-scanner) /usr/local/bin/sonar
