# Supported tags and respective `Dockerfile` links

- [`latest`(*Endlessh/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/Dockerfile)
- [`busybox`(*Endlessh/Dockerfile*)](https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/busybox/Dockerfile)



# Quick Reference

- **Maintained by** : [HarshaVardhanJ](https://github.com/HarshaVardhanJ/docker_files/)
- **Source of this description** : [README in `docker_files` repository]()



# Software Packages Installed

* `endlessh`

There are images with two tags currently - `latest`, and `busybox`. The `latest` image is built on top of the `scratch` base image and therefore it comes with no installed software. The `endlessh` executable is the only software on the `latest` image.

The `busybox` image comes with the usual set of tools that are present in a `busybox` image. 

# Supported Architectures

* `amd64`
* `arm64`
* `arm32v7`
* `arm32v6`
* `i386`
* `s390x`

# Description of Tags

## `latest`

The image with this tag contains no software packages installed except for the `endlessh` executable(which is statically-linked) which is copied to the `scratch` base image. This image is the smallest in size when compared to the `busybox` or `alpine` image. To use this image,  use  the`latest` tag, or no tag at all as follows

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



To use in a swarm, run `docker stack deploy -c stack.yaml harshavardhanj/endlessh` from the manager node in your swarm, wait for it initialise completely, and check if the tarpit is running by trying to connect to it by running `ssh -v root@swarm-ip -p 2222`. 



To use on a local development machine, use `docker-compose -f stack.yaml up` from your local machine, wait for it initialise completely, and check if the tarpit is running by trying to connect to it by running `ssh -v root@swarm-ip -p 2222`. 



In both cases, you should see a very delayed response from the server and some random gibberish banner text that is visible when the connection is attempted in verbose mode (`ssh -v`)



# Image Variants

The `endlessh` image comes in two falvours currently. One is based on the `scratch` base image and the other on `busybox`.



## `endlessh:latest`, `endlessh`

The images with these tags are built on top of the `scratch` base image which is a blank slate. The only utility/software on this image is the `endlessh` executable. Therefore, this image is the smallest in size of the two. This variant is highly recommended as it contains nothing more than the required executable. For more information about the `scratch` image, check the [`scratch` Docker Hub page](https://hub.docker.com/_/scratch).



## `endlessh:busybox`

The image with this tag is built on top of the `busybox` base image. It comes with the standard utilities and tools common to a `busybox` base image. Unless you need access to some of those utilities, the `scratch` image should suit your needs. For more information about the `busybox` image, check the [`busybox` Docker Hub page](https://hub.docker.com/_/busybox).



# License

As with all Docker images, these likely alos contain other software which may be under other license (such as `bash`, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained.)

As for any pre-built image usage, it is the image user’s responsibility to ensure that any use of this image complies with any relevant licenses for all software container within.