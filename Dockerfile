FROM docker.io/library/debian:12.11-slim@sha256:90522eeb7e5923ee2b871c639059537b30521272f10ca86fdbbbb2b75a8c40cd
SHELL ["/bin/bash", "-u", "-e", "-o", "pipefail", "-c"]

RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	apt-get -qq update && \
	apt-get -qq install --yes --no-install-recommends ca-certificates curl jq && \
	rm -rf /etc/*- /var/lib/dpkg/*-old /var/lib/dpkg/status /var/cache/* /var/log/*

COPY --link --chown=0:0 --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
