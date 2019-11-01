# Supported tags and respective `Dockerfile` links

- [`latest`(*Endlessh/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/Dockerfile)
- [`busybox`(*Endlessh/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/busybox/Dockerfile)
- [`alpine`(*Endlessh/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/alpine/Dockerfile)



# Quick Reference

- **Maintained by** : [HarshaVardhanJ](https://github.com/HarshaVardhanJ/docker_files/)
- **Source of this description** : [README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/README.md)
- **Original author of `endlessh`** : [Christopher Wellons](https://github.com/skeeto/endlessh)



# Software Packages Installed

* `endlessh`

There are images with three tags currently - `latest`, `busybox`, and `alpine`. The `latest` image is built on top of the `scratch` base image and therefore it comes with no installed software. The `endlessh` executable is the only software on the `latest` image.

The `busybox` image comes with the usual set of tools that are present in a `busybox` image. The same goes for the `alpine` image which is built on top of Alpine Linux

# Supported Architectures

* `amd64`
* `arm64`
* `arm32v7`
* `arm32v6`
* `i386`
* `s390x`

# Description of Tags

## `latest`

The image with this tag contains no software packages installed except for the `endlessh` executable(which is statically-linked) which is copied to the `scratch` base image. This image is the smallest in size when compared to the `busybox` or `alpine` image. To use this image,  use  the `latest` tag, or no tag at all as follows

```shell
$ docker container run -d --name endlessh -p 2222:2222 \
harshavardhanj/endlessh:latest
```

or

```shell
$ docker container run -d --name endlessh -p 2222:2222 \
harshavardhanj/endlessh
```

Any of the above image tags will pull the image with the `scratch` tag. If you need to just run `endlessh` on a random port, the `scratch` image will suffice.



## `busybox`

The image with this tag is built on top of the `busybox` base image. It contains no extra software installed on it except for the tools that come pre-installed on `busybox`. The `endlessh` executable(which is statically-linked) is copied to the `busybox` base image. To use this image, use the `busybox` tag as follows

```shell
$ docker container run -d --name endlessh -p 2222:2222 \
harshavardhanj/endlessh:busybox
```

As the image is built on top of `busybox`, its size will be significantly larger than the `scratch` image which is less than `0.5 MB` is size. You can use this image if you need some of the additional functionality that comes with the `busybox` image.



## `alpine`

The image with this tag is built on top of the `alpine` base image. It is considerably larger in size than the image `endlessh:latest`. The `endlessh` executable in this image is not statically-linked. To use this image, use the `alpine` tag as follows

```shell
$ docker container run -d --name endlessh -p 2222:2222 \
harshavardhanj/endlessh:alpine
```



# How to use this image

## Start an `endlessh` instance

```shell
$ docker container run -d --name endlessh -p 2222:2222 \
harshavardhanj/endlessh
```

This image exposes port `2222` by default, so standard container linking will make it automatically available to linked containers.



## … via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yaml`/`docker-compose.yaml` for `endlessh`:



```yaml
version: "3.4"
services:
	endlessh:
		image: harshavardhanj/endlessh:latest
		ports:
		- "2222:2222"
		restart: always
```



[![Try in ‘Play With Docker’](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](https://labs.play-with-docker.com?stack=https://raw.githubusercontent.com/HarshaVardhanJ/docker_files/master/endlessh/docker-compose.yml)



After opening the above *Play With Docker* link, you should see a terminal. To check the SSH tarpit, type `ssh -v root@localhost -p 2222`. You should see a verbose output of what the SSH tarpit is returning. It takes about 10 seconds for each response to come through. The tarpit sends a random gibberish text during the connection establishment phase thereby keeping the client locked.



To use in a swarm, run `docker stack deploy -c stack.yaml harshavardhanj/endlessh` from the manager node in your swarm, wait for it initialise completely, and check if the tarpit is running by trying to connect to it by running `ssh -v root@swarm-ip -p 2222`. 



To use on a local development machine, use `docker-compose -f stack.yaml up` from your local machine, wait for it initialise completely, and check if the tarpit is running by trying to connect to it by running `ssh -v root@swarm-ip -p 2222`. 



In both cases, you should see a very delayed response from the server and some random gibberish banner text that is visible when the connection is attempted in verbose mode (`ssh -v`)



# Image Variants

The `endlessh` image comes in three variants currently - `latest`, `busybox`, and `alpine`.



## `endlessh:latest`, `endlessh`

The images with these tags are built on top of the `scratch` base image which is a blank slate. The only utility/software on this image is the `endlessh` executable. Therefore, this image is the smallest in size of the two. This variant is highly recommended as it contains nothing more than the required executable. For more information about the `scratch` image, check the [`scratch` Docker Hub page](https://hub.docker.com/_/scratch).



## `endlessh:busybox`

The image with this tag is built on top of the `busybox` base image. It comes with the standard utilities and tools common to a `busybox` base image. Unless you need access to some of those utilities, the `scratch` image should suit your needs. For more information about the `busybox` image, check the [`busybox` Docker Hub page](https://hub.docker.com/_/busybox).



## `endlessh:alpine`

These images are based on the popular [Alpine Linux project](http://alpinelinux.org), available in [the `alpine` official
image](https://hub.docker.com/_/alpine). Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc](http://www.musl-libc.org) instead of [glibc and friends](http://www.etalabs.net/compare_libcs.html), so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread](https://news.ycombinator.com/item?id=10782897) for more discussion of the issues that might arise and some pro/con comparisons of using Alpine-based images.

To minimize image size, it's uncommon for additional related tools (such as`git` or `bash`) to be included in Alpine-based images.



# Note

In order to minimise the size of the images, the `endlessh` executable in the `busybox` and `scratch` images has been compiled as statically-linked. This was done by adding the `-static` option to the `CFLAGS` in the Makefile. Nothing has been changed in the source code. The original Makefile is given below.



```makefile
.POSIX:
CC      = gcc
CFLAGS  = -std=c99 -Wall -Wextra -Wno-missing-field-initializers -Os
LDFLAGS = -ggdb3
LDLIBS  =
PREFIX  = /usr/local

all: endlessh

endlessh: endlessh.c
  $(CC) $(LDFLAGS) $(CFLAGS) -o $@ endlessh.c $(LDLIBS)

install: endlessh
  install -d $(DESTDIR)$(PREFIX)/bin
  install -m 755 endlessh $(DESTDIR)$(PREFIX)/bin/
  install -d $(DESTDIR)$(PREFIX)/share/man/man1
  install -m 644 endlessh.1 $(DESTDIR)$(PREFIX)/share/man/man1/

clean:
  rm -rf endlessh
```

and the edited part is the `CFLAGS` value. The edited line is given below

```makefile
CFLAGS  = -static -std=c99 -Wall -Wextra -Wno-missing-field-initializers -Os
```

It was necessary to compile the executable to be statically-linked so as to make it run on the `busybox` and `scratch` images. The image with the `alpine` tag which is built on top of Alpine Linux does not have any modification to the Makefile. The container is built by downloading the source code from the repository and building it. Feel free to check the source code if you need to make sure that it has not been modified.



# License

As with all Docker images, these likely also contain other software which may be under other license (such as `bash`, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained.)

As for any pre-built image usage, it is the image user’s responsibility to ensure that any use of this image complies with any relevant licenses for all software container within.

