# Supported tags and respective `Dockerfile` links

-	[`alpine`, `latest` (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/with-sh/openssh/openssh-alpine/Dockerfile)
- [`alpine-bash` (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh/openssh-alpine/Dockerfile)
-	[`debian` (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh/openssh-debian/Dockerfile)

# Quick reference

-	**Maintained by**:
	[Harsha Vardhan J](https://github.com/HarshaVardhanJ/docker_files/)

-	**Source of this description**:
	[README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh/README.md)


# Software Packages installed

* OpenSSH Server (latest version)
* `bash` (Bourne Again Shell), only if using the `alpine-bash` image

# Description of tags

## `alpine`, `latest`

The image with this tag contains the following software packages installed on
top of the base Alpine Linux image.

* OpenSSH Server (latest version)

As bash is not installed, this image is slightly smaller in size than the
`alpine-bash` image. To use this image, use the `alpine` tag as follows

```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:alpine
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

Any of the above commands will pull the image with the `alpine` tag.  


## `alpine-bash`

The image with this tag contains the following software packages installed on
top of the base Alpine Linux image.

* OpenSSH Server (latest version)
* `bash` (Bourne Again Shell)

Due to bash being installed, this image is slightly larger in size than the
`alpine` image. To use this image, use the `alpine-bash` tag as follows

```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:alpine-bash
```  


## `debian`

The image with this tag contains the following software packages installed on
top of the base Debian Stretch image.

* OpenSSH Server (latest version)

This image is considerably larger in size than the `alpine` or `alpine-bash` images
as it is based on Debian. But, this image will come with a lot of tools and utilities
installed by default.  


```console
$ docker container run -d --name ssh -p "2222:22/tcp" \
harshavardhanj/openssh:debian
```  

# How to use this image

## Start an OpenSSH instance

```console
$ docker container run -d --name ssh-server --publish "2222:22/tcp" \
-e USER='test_user' -e PASSWORD='test_password' harshavardhanj/openssh
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
Docker'](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/HarshaVardhanJ/docker_files/with-sh/openssh/openssh-alpine/docker-compose.yml)


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
used. If only the USER variable is specified, the default password will be assigned
to the specified user. When a container is run by the command given below,

```console
$ docker container run --name ssh -p "2222:22/tcp" \
-e USER='test_user' -d harshavardhanj/openssh
```

you can SSH into the container by logging in as the user `test_user` with the
password `docker`.


### `PASSWORD`

This environment variable is recommended for you to use the OpenSSH image. This
environment variable sets the password for user that is defined by the `USER`
environment variable. The default user is defined by the `USER` environment
variable. If the `PASSWORD` environment variable is not specified, the default
value of `docker` is used. If only the PASSWORD variable is specified, the default
user, `docker`,  will be assigned the password specified. When a container is run
by the command given below,  

```console
$ docker container run --name ssh -p "2222:22/tcp" \
-e PASSWORD='test_password' -d harshavardhanj/openssh
```  

you can SSH into the container by logging in as the user `docker` with the password
`test_password`.


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

The `openssh` image comes in two flavours currently. One is based on Alpine Linux
and the other on Debian Stretch


## `openssh:alpine`, `openssh`, `alpine-bash`

These images are based on the popular [Alpine Linux
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


## `openssh:debian`  

This image is based on Debian Stretch Slim, available in [the `debian` official
image](https://hub.docker.com/_/debian). This image is considerably larger in
size when compared to the images based on Alpine Linux, but it has the advantage
of having a larger number of tools and utilities preinstalled in the base image.  


# License

As with all Docker images, these likely also contain other software which may be
under other licenses (such as `bash`, etc from the base distribution, along with
any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to
ensure that any use of this image complies with any relevant licenses for all
software contained within.

