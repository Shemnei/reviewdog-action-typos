FROM alpine:3.19

ENV REVIEWDOG_VERSION=v0.17.1
ENV TYPOS_VERSION=v1.19.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git=2.43.0-r0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

# Install typos
RUN wget -O- -q https://github.com/crate-ci/typos/releases/download/${TYPOS_VERSION}/typos-${TYPOS_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar -zx -C /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
