# `ddclient` Docker Image

# [![](https://images.microbadger.com/badges/version/harshavardhanj/ddclient:stable.svg)](https://microbadger.com/images/harshavardhanj/ddclient:stable "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/harshavardhanj/ddclient:stable.svg)](https://microbadger.com/images/harshavardhanj/ddclient:stable "Get your own commit badge on microbadger.com")
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/ddclient/stable)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/ddclient/stable)
![Docker Pulls](https://img.shields.io/docker/pulls/harshavardhanj/ddclient)
![GitHub](https://img.shields.io/github/license/HarshaVardhanJ/docker_files) AND [![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

In case you find this image to be useful, please consider clicking the link below to say thanks! Thank you.  
[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/vardhanharshaj%40gmail.com)

# Supported tags and respective `Dockerfile` links

- [`3.9.1`, `latest`(*ddclient/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/ddclient/v3.9.1/Dockerfile)

- [`3.9.0`, `stable`(*ddclient/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/ddclient/v3.9.0/Dockerfile)

  

### NOTE:

Apart from the aforementioned images, there are other images that contain `untested` as part of their tag. **Do not use these images.** As the tag suggests, they are present for purposes of testing. In order to test the images with `container-structure-test` and `trivy`, the image needs to be present in a public repository. Therefore, I first build and push the images with an `untested` tag. Then, I run tests on these images. When the image passes all tests, it is built again and pushed with the appropriate tags.



# Quick Reference

- **Maintained by** : [HarshaVardhanJ](https://github.com/HarshaVardhanJ/docker_files/)
- **Source of this description** : [README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/ddclient/README.md)
- **Submit issues with Docker image on** : [GitHub Issues](https://github.com/HarshaVardhanJ/docker_files/issues)  ![GitHub Issues](https://img.shields.io/github/issues/HarshaVardhanJ/docker_files)
- **Submit issues with `ddclient on`** : [GitHub Issues](https://github.com/ddclient/ddclient/issues) ![GitHub Issues](https://img.shields.io/github/issues/ddclient/ddclient)
- **GitHub page of `ddclient`** : [GitHub](https://github.com/ddclient/ddclient)
- **Documentation for `ddclient`** : [`ddclient` Docs](https://ddclient.net)



# Software Packages Installed

* `ddclient`
* `perl` 
* `perl-utils`
* `perl-test-taint`
* `perl-netaddr-ip`
* `perl-net-ip`
* `perl-yaml`
* `perl-log-log4perl`
* `perl-io-socket-ssl`
* `Data::Validate::IP`

There are images with four tags currently - `latest`, `3.9.1`, `stable` , and `3.9.0`. All images are built on top of the `alpine` base image. Currently, the `latest` and `3.9.1` tag point to the same image. The `stable` and `3.9.0` tag point to the same image.

# Supported Architectures

* `amd64`
* `arm64`
* `arm32v7`
* `arm32v6`
* `i386`
* `ppc64le`

# Description of Tags

## `latest`, `3.9.1`

The image with this tag contains no software packages installed except for the `ddclient` executable and its dependencies. To use this image,  use  the `latest` tag, or no tag at all as follows

```shell
$ docker container run -d --name ddclient \
-v /path/to/config/file:/etc/ddclient/ddclient.conf \
harshavardhanj/ddclient:latest
```

or

```shell
$ docker container run -d --name ddclient \
-v /path/to/config/file:/etc/ddclient/ddclient.conf \
harshavardhanj/ddclient
```



## `stable`, `3.9.0`

Just like the `latest` image, this image contains only `ddclient` and its dependencies installed. To use this image, use the `stable` tag, or the `3.9.0` tag as follows

```shell
$ docker container run -d --name ddclient \
-v /path/to/config/file:/etc/ddclient/ddclient.conf \
harshavardhanj/ddclient:stable
```

```shell
$ docker container run -d --name ddclient \
-v /path/to/config/file:/etc/ddclient/ddclient.conf \
harshavardhanj/ddclient:3.9.0
```





# How to use this image

## Start a `ddclient` instance

```shell
$ docker container run -d --name ddclient \
-v /path/to/config/file:/etc/ddclient/ddclient.conf \
harshavardhanj/ddclient
```

Running the above command will start a `ddclient` instance and will follow the dfirectives given in the configuration file(`/etc/ddclient/ddclient.conf`) which has to be bind-mounted to the container.



## … via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yaml`/`docker-compose.yaml` for `ddclient`:



```yaml
version: "3.4"
services:
	endlessh:
		image: harshavardhanj/ddclient:latest
		volumes:
			- "/path/to/config/file:/etc/ddclient/ddclient.conf:ro"
		restart: always
```



[![Try in ‘Play With Docker’](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](https://labs.play-with-docker.com?stack=https://raw.githubusercontent.com/HarshaVardhanJ/docker_files/master/ddclient/v3.9.0/docker-compose.yml)



After opening the above *Play With Docker* link, you should see a terminal.

To use in a swarm, run `docker stack deploy -c stack.yaml harshavardhanj/ddclient` from the manager node in your swarm, and wait for it initialise completely. To use on a local development machine, use `docker-compose -f stack.yaml up` from your local machine, and wait for it initialise completely. 



# Image Variants



## `ddclient:latest`, `ddclient:stable`, `ddclient`

These images are based on the popular [Alpine Linux project](http://alpinelinux.org), available in [the `alpine` official
image](https://hub.docker.com/_/alpine). Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc](http://www.musl-libc.org) instead of [glibc and friends](http://www.etalabs.net/compare_libcs.html), so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread](https://news.ycombinator.com/item?id=10782897) for more discussion of the issues that might arise and some pro/con comparisons of using Alpine-based images.

To minimize image size, it's uncommon for additional related tools (such as`git` or `bash`) to be included in Alpine-based images.



# License

As with all Docker images, these likely also contain other software which may be under other license (such as `bash`, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained.)

As for any pre-built image usage, it is the image user’s responsibility to ensure that any use of this image complies with any relevant licenses for all software container within.

The license for `endlessh` as given on the author's GitHub page is [![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html). The license for the code pertaining to the Docker container as given on my GitHub page is ![GitHub](https://img.shields.io/github/license/HarshaVardhanJ/docker_files).

