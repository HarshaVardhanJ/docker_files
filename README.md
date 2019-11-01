# Repository for Dockerfiles and other related files of containerised applications  

# Quick reference  

-	**Maintained by**:
	[Harsha Vardhan J](https://github.com/HarshaVardhanJ/docker_files)

-	**Source of this description**:
	[README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/README.md)


# Software  

* [OpenSSH](https://www.openssh.com/) - A secure shell server
* [Gitea](https://gitea.io/en-us) - A self-hosted Git repository
* [Nginx](https://nginx.org/en/) - A high-performance web server
* [ddclient](https://ddclient.net/) - A client used for updating dynamic DNS records
* [endlessh](https://github.com/skeeto/endlessh) - An SSH tarpit


# Supported Architectures  

* `amd64`
* `arm64`
* `arm32v7`
* `arm32v6`
* `i386`
* `s390x`  


## Note about image size  

All images are built to have the smallest image size possible without sacrificing functionality.
To that end, almost every image begins either with the Alpine Linux base image or from scratch.


## Note about autobuilds on DockerHub  

DockerHub currently supports autobuilding images for the x86 architecture only. Therefore, autobuilds
will not be used. The images will be built elsewhere and pushed to DockerHub.


# Image Variants  


# `openssh`  

The `openssh` image comes in two variants(and three tags) currently.

-	`openssh:alpine` (based on [Alpine Linux](https://hub.docker.com/_/alpine/))
-	`openssh:alpine-bash` (based on [Alpine Linux](https://hub.docker.com/_/alpine/), with `bash` installed)
-	`openssh:debian` (based on [Debian Stretch](https://hub.docker.com/_/debian/))  


## `openssh:alpine`

This is the defacto image. If you are unsure about what your needs are, you
probably want to use this one.

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


## `openssh:alpine-bash`  

This image is slightly larger than the default `alpine` image as it has `bash` installed
in the image. For most cases, you will not need to use this image unless you need something
that requires the presence of `bash`. In the future, this image will be removed.  


## `openssh:debian`  

This image is based on the Debian Stretch Slim distribution. This image is considerably
larger than the Alpine Linux image.  


# License

As with all Docker images, these likely also contain other software which may be
under other licenses (such as Bash, etc from the base distribution, along with
any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to
ensure that any use of this image complies with any relevant licenses for all
software contained within.
