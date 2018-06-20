# Supported tags and respective `Dockerfile` links

- 	[`alpine-bash`, `latest`, (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh-alpine/Dockerfile)
-	[`alpine`, (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/with-sh/openssh-alpine/Dockerfile)
-	[`jessie`, (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh-debian/Dockerfile)
-	[`ubuntu`, (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh-ubuntu/Dockerfile)

# Quick reference

-	**Maintained by**:
	[Harsha Vardhan J](https://github.com/HarshaVardhanJ/docker_files/master/openssh-alpine)

-	**Source of this description**:
	[README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/README.md)


# Software Packages installed

* OpenSSH Server (latest version)
* Bash (Bourne Again Shell), only if using the `alpine-bash`, `ubuntu`, and `jessie` image

# Description of tags

## `alpine-bash`, `latest`

The image with this tag contains the following software packages installed on
top of the base Alpine Linux image.

* OpenSSH Server (latest version)
* Bash (Bourne Again Shell)

Due to Bash being installed, this image is slightly larger in size than the
`without-bash` image. To use this image, use the `with-bash` tag as follows

```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:alpine-bash
```  
or
```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:latest
```  
or 
```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh
```  

Any of the above commands will pull the image with the `with-bash` tag.

## `alpine`

The image with this tag contains the following software packages installed on
top of the base Alpine Linux image.

* OpenSSH Server (latest version)

As Bash is not installed, this image is slightly smaller in size than the
`with-bash` image. To use this image, use the `without-bash` tag as follows

```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:alpine
```  

## `jessie`

The image with this tag contains the following software packages installed on
top of the base [`debian:jessie-slim`](https://github.com/debuerreotype/docker-debian-artifacts/blob/b024a792c752a5c6ccc422152ab0fd7197ae8860/jessie/slim/Dockerfile)
image, which is the base image of Debian Jessie Slim.

* OpenSSH Server (latest version)
* Bash (latest version)

To use this image, use the `jessie` tag as follows  

```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:jessie
```  

## `ubuntu`

The image with this tag contains the followings software packages installed on
top of the base
[`phusion/baseimage`](https://github.com/phusion/baseimage-docker) image, which
is the base image of Ubuntu 
that has been modified to fit well with containerisation tools like Docker.

* OpenSSH Server (latest version)
* Bash (latest version)

To use this image, use the `ubuntu` tag as follows

```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:ubuntu
```  

# How to use this image

## Start an OpenSSH instance

```console
$ docker container run --name ssh-server --publish "2222:22/tcp" \
-e USER=test_user -e PASSWORD=test_password -d harshavardhanj/openssh
```

This image includes `EXPOSE 22` (the standard SSH port), so standard container
linking will make it automatically available to linked containers. The default
user that you can login as is created in the entrypoint script.

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `openssh`:

```yaml
# Use OpenSSH example user/password credentials
version: '3.4'

services:
	ssh:
		image: harshavardhanj/openssh:latest
		ports:
			- "2222:22"
		restart: always
		environment:
			- USER=example
			- PASSWORD=example
```  
  

[![Try in 'Play With
Docker'](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/HarshaVardhanJ/docker_files/with-sh/openssh-alpine/docker-compose.yml)


To use in a swarm, run `docker stack deploy -c stack.yml harshavardhanj/openssh`
from the manager node in your swarm, wait for it to initialize completely, and
try to connect using `ssh example@swarm-ip -p 2222`.  

To use on a local development machine, use `docker-compose -f stack.yml up` from
your local machine, wait for it to initialize completely, and try to connect
using `ssh example@localhost -p 2222`, or `ssh example@host-ip -p 2222` (as
appropriate).  

## Environment Variables

The OpenSSH image uses three environment variables. While none of the variables
are required, they will aid you in customising certain aspects of the OpenSSH
server for better security.

### `USER`  

This environment variable is used in conjunction with `PASSWORD` to set its
username and password. This variable will create the specified user that you can
login as. If it is not specified, then the default user of `docker` will be
used.


### `PASSWORD`

This environment variable is recommended for you to use the OpenSSH image. This
environment variable sets the password for user that is defined by the `USER`
environment variable. The default user is defined by the `USER` environment
variable. If the `PASSWORD` environment variable is not specified, the default
value of `docker` is used.


### `SSH_PUBKEY`

This environment variable is recommended for you to use the OpenSSH image. This
environment variable adds the SSH public-key for the user defined by the `USER`
environment variable. Using the `SSH_PUBKEY` variable, you can login using
key-based authentication. It is preferable to use `docker secrets` to pass the
`SSH_PUBKEY` environment variable. If this not possible, you can pass the
public-key as follows

```console
$ docker container run --name ssh -p "2222:22/tcp" \
-e SSH_PUBKEY="$(cat /path/to/public/key.pub)" -d harshavardhanj/openssh
```

The double-quotes for passing the public-key is necessary to prevent
word-splitting by the shell.


### Docker Secrets

As an alternative to passing sensitive information via environment variables,
`_FILE` may be appended to the previously listed environment variables, causing
the initialization script to load the values for those variables from files
present in the container. In particular, this can be used to load passwords from
Docker secrets stored in `/run/secrets/<secret_name>` files. For example:

```console
$ docker container run --name ssh -p "2222:22/tcp" \
-e PASSWORD_FILE=/run/secrets/ssh_password -d harshavardhanj/openssh
```

# Image Variants

The `openssh` image comes in two variants(and three tags) currently.

-	`openssh:alpine-bash` (based on Alpine Linux, with Bash installed)
-	`openssh:alpine` (based on Alpine Linux, without Bash installed)
-	`openssh:jessie` (based on Debian Jessie Slim)
-	`openssh:ubuntu` (based on
	[`phusion/baseimage`](https://hub.docker.com/r/phusion/baseimage/) which is
	built on Ubuntu)

For more information on the image that is built on top of `phusion/baseimage` image
which is modified version of Ubuntu suitable for containerisation purposes, please take a look at `phusion/baseimage`'s repository on
[GitHub](https://github.com/phusion/baseimage-docker) and [DockerHub](https://hub.docker.com/r/phusion/baseimage/).


## `openssh:<version>`

This is the defacto image. If you are unsure about what your needs are, you
probably want to use this one.


## `openssh:alpine`

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

## `openssh:jessie`  

This image is based on the Debian Jessie Slim distribution.  

## `openssh:ubuntu`  

This image is based on the `phusion:baseimage` image which, as described
previously, is based on Ubuntu with improvements.  


# License

As with all Docker images, these likely also contain other software which may be
under other licenses (such as Bash, etc from the base distribution, along with
any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to
ensure that any use of this image complies with any relevant licenses for all
software contained within.
