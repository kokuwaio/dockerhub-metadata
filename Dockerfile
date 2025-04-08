FROM docker.io/library/debian:12.10-slim@sha256:b1211f6d19afd012477bd34fdcabb6b663d680e0f4b0537da6e6b0fd057a3ec3
SHELL ["/bin/bash", "-u", "-e", "-o", "pipefail", "-c"]

RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	apt-get -qq update && \
	apt-get -qq install --yes --no-install-recommends ca-certificates curl jq && \
	rm -rf /etc/*- /var/lib/dpkg/*-old /var/lib/dpkg/status /var/cache/* /var/log/*

COPY --link --chown=0:0 --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
