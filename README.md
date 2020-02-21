# Repository for Dockerfiles and other related files of containerised applications  

# Quick reference  

-	**Maintained by**:
	[Harsha Vardhan J](https://github.com/HarshaVardhanJ/docker_files)

# Supported tags and respective `Dockerfile` links

-	[`alpine`, `latest` (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/with-sh/openssh/openssh-alpine/Dockerfile)
-	[`debian` (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh/openssh-debian/Dockerfile)

# Quick reference

-	**Maintained by**:
	[Harsha Vardhan J](https://github.com/HarshaVardhanJ/)

-	**Source of this description**:
	[README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/README.md)

# Software  

* [OpenSSH](https://www.openssh.com/) - A secure shell server
* [Docker-buildx](https://docs.docker.com/buildx/working-with-buildx/) - Docker with `buildx` support for building multi-arch images
* [Gitea](https://gitea.io/en-us) - A self-hosted Git repository
* [Nginx](https://nginx.org/en/) - A high-performance web server
* [ddclient](https://ddclient.net/) - A client used for updating dynamic DNS records
* [endlessh](https://github.com/skeeto/endlessh) - An SSH tarpit


# Supported Architectures  

* `amd64`
* `arm64`
* `arm32v7`
* `arm32v6`
* `i386` (Unsupported for a few images. Check the README for the image to confirm.)
* `s390x` (Unsupported for a few images. Check the README for the image to confirm.)


## Note about image size  

All images are built to have the smallest image size possible without sacrificing functionality.
To that end, almost every image begins either with the Alpine Linux base image or from scratch.


## Note about autobuilds on DockerHub  

DockerHub currently supports autobuilding images for the x86 architecture only. Therefore, autobuilds
will not be used. The images will be built elsewhere and pushed to DockerHub. Currently, most of the
images are built with Google Cloud Platform's Cloud Build by using a custom `docker-buildx` image,
which is Docker built with `buildx` support, and are then pushed to Docker Hub. This way the images 
are being built for multiple architectures.


# Image Variants


## `<image>:alpine`

This image is based on the popular [Alpine Linux
project](http://alpinelinux.org), available in [the `alpine` official
image](https://hub.docker.com/_/alpine). Alpine Linux is much smaller than most
distribution base images (~5MB), and thus leads to much slimmer images in
general.

This variant is highly recommended when final image size being as small as
possible is desired. The main caveat to note is that it does use [musl
libc](http://www.musl-libc.org) instead of [glibc and
friends](http://www.etalabs.net/compare_libcs.html), so certain software might
run into issues depending on the depth of their libc requirements. However, most
software doesn't have an issue with this, so this variant is usually a very safe
choice. See [this Hacker News comment
thread](https://news.ycombinator.com/item?id=10782897) for more discussion of
the issues that might arise and some pro/con comparisons of using Alpine-based
images.  

To minimize image size, it's uncommon for additional related tools (such as
`git` or `bash`) to be included in Alpine-based images. Using this image as a
base, add the things you need in your own Dockerfile (see the [`alpine` image
description](https://hub.docker.com/_/alpine/) for examples of how to install
packages if you are unfamiliar).  


# License

As with all Docker images, these likely also contain other software which may be
under other licenses (such as Bash, etc from the base distribution, along with
any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to
ensure that any use of this image complies with any relevant licenses for all
software contained within.
