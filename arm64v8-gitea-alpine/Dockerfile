# Dockerfile for creating a container that runs Gitea

#FROM alpine:latest as arm-builder

#RUN apk update \
#	&& apk add --no-cache curl tar \
#	&& curl -L https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz \
#	| tar zxvf - -C . && mv qemu-3.0.0+resin-arm/qemu-arm-static .
#
#WORKDIR /
#
FROM arm64v8/golang:1.11.4-alpine3.8 as gitea-build

# Copy across the qemu binary that was downloaded in the previous build step
#COPY --from=arm-builder /qemu-arm-static /usr/bin

MAINTAINER "Harsha Vardhan J <vardhanharshaj@gmail.com>"

RUN apk add --no-cache --virtual .go-deps \
	gcc \
	git \
	make \
	musl-dev

ENV GOPATH="/go"
ENV SRC_DIR="${GOPATH}/src/code.gitea.io/gitea"

RUN go get -d -u code.gitea.io/gitea
WORKDIR "$SRC_DIR"

ARG BUILD_TAGS="bindata sqlite sqlite_unlock_notify"

RUN TAGS="${BUILD_TAGS}" make generate build

FROM arm64v8/alpine:latest

COPY --from=gitea-build /go/src/code.gitea.io/gitea/gitea /usr/local/bin/gitea

RUN apk add --no-cache --virtual .gitea-deps \
	linux-pam \
	bash \
	git \
	sqlite \
	su-exec \
	tzdata \
	&& addgroup -S -g 1000 git \
	&& adduser \
		-S \
		-s "/bin/bash" \
		-g "Git Version Control for Gitea" \
		-G git \
		-D \
		-u 1000 \
		-H \
		-h "/data/git" \
		git \
	&& set -euo pipefail ; \
	echo "root:$(head -c 32 /dev/urandom | base64)" | chpasswd ; \
    echo "git:$(head -c 32 /dev/urandom | base64)" | chpasswd


EXPOSE 22 3000

VOLUME ["/data"]

ENTRYPOINT ["gitea", "web"]
