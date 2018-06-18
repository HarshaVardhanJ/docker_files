## Repository for Dockerfiles and other allied configuration files related to Docker

# Supported tags and respective `Dockerfile` links

- 	[`with-sh`, `latest`, (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/with-sh/openssh-alpine/Dockerfile)
-	[`with-bash`, `latest`, (*OpenSSH/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh-alpine/Dockerfile)

# Quick reference

-	**Maintained by**:
	[Harsha Vardhan J](https://github.com/HarshaVardhanJ/docker_files/master/openssh-alpine)

-	**Source of this description**:
	[README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/README.md)


# How to use this image

## Start an OpenSSH instance

```console
$ docker container run --name ssh-server --publish "2222:22/tcp" \
-e USER=test_user -e PASSWORD=test_password -d harshavardhanj/openssh
```

This image includes `EXPOSE 22` (the standard SSH port), so standard container linking will make it automatically available to linked containers.
The default user that you can login as is created in the entrypoint script.

## ... via [`docker stack deploy`]((https://docs.docker.com/engine/reference/commandline/stack_deploy/) or 
[`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `openssh`:

```yaml
# Use openssh/example user/password credentials
version: '3.1'

services:
	
	ssh:
		image: harshavardhanj/openssh:latest
		ports:
			- "2222:22"
		restart: always
		environment:
			- USER: example
			- PASSWORD: example
```

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com?
stack=https://raw.githubusercontent.com/HarshaVardhanJ/docker_files/with-sh/openssh-alpine/docker-compose.yml)

Run `docker stack deploy -c stack.yml harshavardhanj/openssh` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, 
and try to connect using `ssh example@swarm-ip -p 2222`, `ssh example@localhost -p 2222`, or `ssh example@host-ip -p 2222` (as appropriate).

## Environment Variables

The OpenSSH image uses three environment variables. While none of the variables are required, they will aid you in customising certain aspects
of the OpenSSH server for better security.

### `USER`

This environment variable is used in conjunction with `PASSWORD` to set its username and password. This variable will create the specified user
that you can login as. If it is not specified, then the default user of `docker` will be used.


### `PASSWORD`

This environment variable is recommended for you to use the OpenSSH image. This environment variable sets the password for user that is defined 
by the `USER` environment variable. The default user is defined by the `USER` environment variable. If the `PASSWORD` environment variable is not
specified, the default value of `docker` is used.


### `SSH_PUBKEY`

This environment variable is recommended for you to use the OpenSSH image. This environment variable adds the SSH public-key for the user defined by
the `USER` environment variable. Using the `SSH_PUBKEY` variable, you can login using key-based authentication. It is preferable to use `docker secrets`
to pass the `SSH_PUBKEY` environment variable. If this not possible, you can pass the public-key as follows

```console
$ docker container run --name ssh -p "2222:22/tcp" -e SSH_PUBKEY="$(cat /path/to/public/key.pub)" -d harshavardhanj/openssh
```

The double-quotes for passing the public-key is necessary to prevent word-splitting by the shell.


### Docker Secrets

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to the previously listed environment variables,
causing the initialization script to load the values for those variables from files present in the container. In particular, this can be used to load 
passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:

```console
$ docker container run --name ssh -p "2222:22/tcp" -e PASSWORD_FILE=/run/secrets/ssh_password -d harshavardhanj/openssh
```

# Image Variants

The `openssh` image comes in one flavour currently. In the future, more variants will be added.


## `openssh:<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as
a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.


## `openssh:alpine`

This image is based on the popular [Alpine Linux project](http://alpinelinux.org), available in [the `alpine` official image](https://hub.docker.com/_/alpine).
Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use 
[musl libc](http://www.musl-libc.org) instead of [glibc and friends](http://www.etalabs.net/compare_libcs.html), so certain software might run 
into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually 
a very safe choice. See [this Hacker News comment thread](https://news.ycombinator.com/item?id=10782897) for more discussion of the issues that 
might arise and some pro/con comparisons of using Alpine-based images.

To minimize image size, it's uncommon for additional related tools (such as `git` or `bash`) to be included in Alpine-based images. Using this image as a base, add the
things you need in your own Dockerfile (see the [`alpine` image description](https://hub.docker.com/_/alpine/) for examples of how to install packages if you are unfamiliar).

# License

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any 
direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all
software contained within.
