# ignore pipefail because
# bash is non-default location https://github.com/tianon/docker-bash/issues/29
# hadolint only uses default locations https://github.com/hadolint/hadolint/issues/977
# hadolint global ignore=DL4006

FROM docker.io/library/bash:5.3.3@sha256:cc444a5a327f8e42318b2772b392f8dd1a9dcb9e00d3c847cc9e419eefa20419
SHELL ["/usr/local/bin/bash", "-u", "-e", "-o", "pipefail", "-c"]

RUN ARCH=$(uname -m) && \
	[[ $ARCH == x86_64 ]] && export SUFFIX=amd64; \
	[[ $ARCH == aarch64 ]] && export SUFFIX=arm64; \
	[[ -z ${SUFFIX:-} ]] && echo "Unknown arch: $ARCH" && exit 1; \
	wget -q "https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-$SUFFIX" --output-document=/usr/local/bin/jq && \
	chmod 555 /usr/local/bin/jq

RUN ARCH=$(uname -m) && \
	[[ $ARCH == x86_64 ]] && export SUFFIX=x86_64; \
	[[ $ARCH == aarch64 ]] && export SUFFIX=aarch64; \
	[[ -z ${SUFFIX:-} ]] && echo "Unknown arch: $ARCH" && exit 1; \
	wget -q "https://github.com/stunnel/static-curl/releases/download/8.16.0/curl-linux-$SUFFIX-glibc-8.16.0.tar.xz" --output-document=- | tar --xz --extract -o --directory=/usr/local/bin curl && \
	chmod 555 /usr/local/bin/curl

COPY --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
