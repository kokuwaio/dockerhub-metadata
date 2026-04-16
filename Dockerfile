# ignore pipefail because
# bash is non-default location https://github.com/tianon/docker-bash/issues/29
# hadolint only uses default locations https://github.com/hadolint/hadolint/issues/977
# hadolint global ignore=DL4006

FROM docker.io/library/bash:5.3.9@sha256:80e26d49514c8660876a7db371ee93231a336716a1fd8e9908c8fb7fad88f270
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
	wget -q "https://github.com/stunnel/static-curl/releases/download/8.19.0/curl-linux-$SUFFIX-glibc-8.19.0.tar.xz" --output-document=- | tar --xz --extract -o --directory=/usr/local/bin curl && \
	chmod 555 /usr/local/bin/curl

COPY --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
