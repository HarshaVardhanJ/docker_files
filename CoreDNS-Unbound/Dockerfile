######## Dockerfile for CoreDNS Server with Unbound Support #########
#                                                                   #
#####################################################################
#  CONTAINERISED COREDNS WITH UNBOUND BUILT ON TOP OF ALPINE LINUX  #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1.# 
#    2.#
#    3.# 
#    5.#
#    6.#
#    7.#
#    8.#
#    9.#
#                                                                   #
# Note :#
#       #
#                                                                   #
#####################################################################

# ARG values for injecting metadata during build time
# NOTE: When using ARGS in a multi-stage build, remember to redeclare
#       them for the stage that needs to use it. ARGs last only for the
#       lifetime of the stage that they're declared in.
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG COREDNS_VERSION=1.7.1

# Starting with Go(alpine) as first stage
FROM golang:alpine AS build

# Environment variable(setting GOPATH)
ENV GOPATH="/go"
ENV PATH="${GOPATH}:${GOPATH}/bin:${PATH}"

# Install dependencies for building CoreDNS
RUN apk add --no-cache --virtual .go-deps \
      build-base \
      gcc \
      git \
      make \
      musl-dev \
      unbound-dev \
    # Cloning the CoreDNS repository
    && git clone https://github.com/coredns/coredns \
    && cd coredns \
    # Checkout specific version
    && git checkout $COREDNS_VERSION \
    # Enable CGO in Makefile
    && sed -ri 's/^CGO_ENABLED:=[0-1]/CGO_ENABLED:=1/g' Makefile

# Changing working directory
WORKDIR /go/coredns

# Copy custom plugin file from host
COPY plugin.cfg ./plugin.cfg

# Create binary
RUN go generate \
    && CGO_ENABLED=1 make

# Final stage
FROM alpine:3.12

# Install Unbound libraries and CA certificates
RUN apk update && apk add --no-cache unbound-libs ca-certificates \
    && addgroup -S -g 1000 coredns \
    && adduser -h /coredns -g "User account for running CoreDNS" \
    -s /sbin/nologin -S -D -G coredns -u 1000 coredns \
    && mkdir -p /coredns \
    && chown -R coredns:coredns /coredns

# Copy binary from build stage
COPY --from=build --chown=coredns:coredns /go/coredns/coredns /usr/local/bin/coredns
# Copy certificate and key from host
COPY --chown=coredns:coredns key.pem cert.pem /usr/local/share/ca-certificates/

# Update certificates
RUN update-ca-certificates

# Run as 'coredns' user
USER coredns

# Expose ports for healthcheck, classic DNS(over UDP), DoT, and DoH
EXPOSE 8080 1053 1054 443

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

# Healthcheck command used to check if CoreDNS is up and running
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=5 CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Run 'coredns' binary as entrypoint command
ENTRYPOINT ["coredns"]

# Passing config file as argument to entrypoint
CMD ["-conf", "/coredns/Corefile"]

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.title="CoreDNS" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/[repo]/tree/[branch]/[directory]" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/[repo]/tree/[branch]/[directory]" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/[repo]/blob/[branch]/[directory]/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/[repo]/blob/[branch]/[directory]/Dockerfile" \
      org.opencontainers.image.description="Adblocking, caching, and recursive DNS server using CoreDNS." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
