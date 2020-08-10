# `pwndrop`

[![](https://images.microbadger.com/badges/version/harshavardhanj/pwndrop.svg)](https://microbadger.com/images/harshavardhanj/pwndrop "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/harshavardhanj/pwndrop.svg)](https://microbadger.com/images/harshavardhanj/pwndrop "Get your own commit badge on microbadger.com")
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/pwndrop/1.0.0)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/pwndrop/1.0.0)
![Docker Pulls](https://img.shields.io/docker/pulls/harshavardhanj/pwndrop)


![GitHub](https://img.shields.io/github/license/HarshaVardhanJ/docker_files) AND ![GitHub](https://img.shields.io/github/license/kgretzky/pwndrop)



From Pwndrop's GitHub page

> pwndrop is a self-deployable file hosting service for sending out red teaming payloads or securely sharing your private files over HTTP and WebDAV.

For more information, please visit the software author's(Kuba Gretzky) [GitHub page](https://github.com/kgretzky/pwndrop).




In case you find this image to be useful, please consider clicking the link below to say thanks! Thank you.  
[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/vardhanharshaj%40gmail.com)


# Supported tags and respective `Dockerfile` links

* [`alpine-1.0.0`](https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/v1.0.0/alpine/Dockerfile)

* [`latest`, `alpine`,`alpine-1.0.1`, `alpine-latest`, `stable`](https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/v1.0.1/alpine/Dockerfile)

* [ `busybox-1.0.0`](https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/v1.0.0/busybox/Dockerfile)

* [`busybox`, `busybox-1.0.1`, `busybox-latest`](https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/v1.0.1/busybox/Dockerfile)

* [`scratch-1.0.0`](https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/v1.0.0/scratch/Dockerfile)

* [`scratch`, `scratch-1.0.1`, `scratch-latest`](https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/v1.0.1/scratch/Dockerfile)

* [`alpine-nonroot-1.0.0`](https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/v1.0.0/alpine/Dockerfile)

* [`alpine-nonroot-1.0.1`, `alpine-nonroot-latest`, `latest-nonroot`, `stable-nonroot`, `nonroot`](https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/v1.0.1/alpine/Dockerfile)

* [`busybox-nonroot-1.0.0`](https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/v1.0.0/busybox/Dockerfile)

* [`busybox-nonroot-1.0.1`, `busybox-nonroot`,`busybox-nonroot-latest`](https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/v1.0.1/busybox/Dockerfile)

* [`scratch-nonroot-1.0.0`](https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/v1.0.0/scratch/Dockerfile)

* [`scratch-nonroot-1.0.1`, `scratch-nonroot`,`scratch-nonroot-latest`](https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/v1.0.1/scratch/Dockerfile)

  

### NOTE:

Apart from the aforementioned images, there are other images that contain `untested` as part of their tag. **Do not use these images.** As the tag suggests, they are present for purposes of testing. In order to test the images with `container-structure-test` and `trivy`, the image needs to be present in a public repository. Therefore, I first build and push the images with an `untested` tag. Then, I run tests on these images. When the image passes all tests, it is built again and pushed with the appropriate tags.



# Quick Reference

- **Image maintained by** : [HarshaVardhanJ](https://github.com/HarshaVardhanJ/docker_files/)
- **Source of this description** : [README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/README.md)
- **Submit issues with image on** : [GitHub Issues](https://github.com/HarshaVardhanJ/docker_files/issues)  ![GitHub Issues](https://img.shields.io/github/issues/HarshaVardhanJ/docker_files)
- **Submit issues with `pwndrop` on** : [GitHub Issues](https://github.com/kgretzky/pwndrop/issues) ![GitHub Issues](https://img.shields.io/github/issues/kgretzky/pwndrop)
- **Creator of `pwndrop`** : [Kuba Gretzky](https://github.com/kgretzky/pwndrop)



# Software Packages Installed

The container image does not contain any other software packages installed except for the ones that come with the base image that it is built on, and the `pwndrop` executable.

The `nonroot` variant contains `libpcap` installed in order to allow the non-root user to bind to privileged ports.

The `scratch`, `busybox`, and `alpine` images do not contain any extra packages installed.



# Supported Architectures

Given below is a list of architectures for which Gitea has been built. In the near future, more architectures will be added.

* `amd64`
* `arm64`
* `arm32v6`
* `ppc64le`
* `s390x`
* `i386`



# Description of tags

### `latest`, `alpine`, `alpine-1.0.0`,  `alpine-1.0.1` `alpine-latest`, `stable` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/pwndrop/latest) ![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/pwndrop/latest)

The images with this tag are built on top of Alpine Linux. There are no additional packages installed over the base Alpine image except for the `pwndrop` executable. To use this image,  use the `alpine` tag as follows:

```shell
$ docker run -d --name pwndrop -p 8000:80 -p 8443:443 -v /full/path/to/host/dir:/pwndrop/data harshavardhanj/pwndrop:alpine
```



### `busybox`, `busybox-1.0.0`, `busybox-1.0.1`,  `busybox-latest` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/pwndrop/busybox) ![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/pwndrop/busybox)

The images with this tag are built on top of Busybox. Similiar to the `alpine` tag, this image does not contain any other additional packages other the `pwndrop` executable. This image is smaller in size when compared to the `alpine` image. To use this image, use the `busybox` tag as follows:

```shell
$ docker run -d --name pwndrop -p 8000:80 -p 8443:443 -v /full/path/to/host/dir:/pwndrop/data harshavardhanj/pwndrop:busybox
```



### `scratch`, `scratch-1.0.0`, `scratch-1.0.1`, `scratch-latest` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/pwndrop/scratch) ![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/pwndrop/scratch)

The images with this tag are built on top of Scratch(essentially, a blank slate). It goes without saying that no other packages can be installed on this. Only the `pwndrop` executable exists in this image. Since the image is built on scratch, this image is the smallest in size(a little over 6 MB). If you’re looking for the image with the smallest storage footprint, this is the one. To use this image, use the `scratch` tag as follows:

```shell
$ docker run -d --name pwndrop -p 8000:80 -p 8443:443 -v /full/path/to/host/dir:/pwndrop/data harshavardhanj/pwndrop:scratch
```



### `nonroot`, `nonroot-1.0.0`  ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/pwndrop/nonroot)  ![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/pwndrop/nonroot) 

The images with this tag, as the name states, is built with security in mind. The ‘run-as’ user in the container is a non-root user. The `pwndrop` process is also started by this user. If you prefer running containers which run processes as non-root users, this is the image for you. To use this image, use the `nonroot` tag as follows:

```shell
$ docker run -d --name pwndrop -p 8000:80 -p 8443:443 -v /full/path/to/host/dir:/pwndrop/data harshavardhanj/pwndrop:nonroot
```





# How to use this image

## Start a `pwndrop` instance


A basic instance can be set up with the following one-liner command

```shell
$ docker container run -d --name pwndrop -p 8000:80 -p 8443:443 -v /full/path/to/host/dir:/pwndrop/data harshavardhanj/pwndrop:latest
```

This will set up a basic instance of pwndrop on your machine. Port 8000 has been connected to port 80 on the container, and port 8443 to port 443 on the container. So, in order to access the web server, you will need to open the URL `http://localhost:8000/` in order to access the installation screen. Also, create an empty directory so you can bind-mount it to `pwndrop`. 

All your data will be saved in this directory. So if you need to terminate the instance and restart it, you can do so without any loss of data. You can just stop the container, which will leave your volume untouched. Later, you can run another instance of `pwndrop` and bind-mount the same volume in order to continue from where you left off. 

Also, in order to access the login page, you will need to navigate to a specific 'secret' path. By default, this path is `/pwndrop`. If you do not navigate to this path, you will receive either a 404 error message or will be redirected to a site that can be configured in the `pwndrop.ini` file. So, the URL to be opened is `http://localhost:8000/pwndrop`.



## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yaml`/`docker-compose.yaml` for Pwndrop:

```yaml
version: "3.4"
services:
  pwndrop:
    image: harshavardhanj/pwndrop:busybox-nonroot
    restart: always
    ports:
      - "8000:8080"
      - "8443:8443"
    volumes:
    	- "/path/to/host/dir:/pwndrop/data"
```

[![Try in ‘Play With Docker’](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](https://labs.play-with-docker.com?stack=https://raw.githubusercontent.com/HarshaVardhanJ/docker_files/master/pwndrop/docker-compose.yaml)



**NOTE: The above Play With Docker link does not work as PWD uses port 80 and 443. These ports are required to be free by `pwndrop`. Therefore, this will not work on Play With Docker.**

The above YAML file should be sufficient to set up a basic instance of Pwndrop. For more information, visit the [official Pwndrop documentation page](https://github.com/kgretzky/pwndrop).



# License

As with all Docker images, these likely also contain other software which may be under other license (such as `bash`, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained.)

As for any pre-built image usage, it is the image user’s responsibility to ensure that any use of this image complies with any relevant licenses for all software container within.

The license for the code pertaining to the Docker container as given on my GitHub page is ![GitHub](https://img.shields.io/github/license/HarshaVardhanJ/docker_files).

The license for the software (`pwndrop`) is ![GitHub](https://img.shields.io/github/license/kgretzky/pwndrop).
