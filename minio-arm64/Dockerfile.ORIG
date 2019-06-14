# Use arm64v8 version of Alpine Linux
FROM arm64v8/alpine

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      description="This Dockerfile creates an ARM64 image of MinIO. Pass the \
      access key and secret key as environment variables to the container after \
      importing the image." \
      version="0.1"

# Install cURL package
RUN apk update \
	&& apk add --no-cache --virtual .download-deps \
	curl

# Download ARM version of minio from their downloads page
RUN curl --silent --show-error --fail --location \
	--header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o /usr/bin/minio \
	"https://dl.minio.io/server/minio/release/linux-arm/minio" \
	&& chmod 0755 /usr/bin/minio \
	&& apk del .download-deps

# Port to be exposed
EXPOSE 9000

# Entrypoint command to be run
ENTRYPOINT ["minio"]

# Volume to be attached
VOLUME ["/data"]
