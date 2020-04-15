# Gitea Docker Image


[![](https://images.microbadger.com/badges/version/harshavardhanj/gitea.svg)](https://microbadger.com/images/harshavardhanj/gitea "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/harshavardhanj/gitea.svg)](https://microbadger.com/images/harshavardhanj/gitea "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/license/harshavardhanj/gitea.svg)](https://microbadger.com/images/harshavardhanj/gitea "Get your own license badge on microbadger.com")
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/gitea/1.11.0)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/gitea/1.11.0)
![Docker Pulls](https://img.shields.io/docker/pulls/harshavardhanj/gitea)


In case you find this image to be useful, please consider clicking the link below to say thanks! Thank you.  
[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/vardhanharshaj%40gmail.com)


# Supported tags and respective `Dockerfile` links

* [`latest`, `1.11.4`](https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/v1.11.4/Dockerfile)
* [`1.11.3`](https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/v1.11.3/Dockerfile)
* [`1.11.2`](https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/v1.11.2/Dockerfile)
* [`1.11.1`](https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/v1.11.1/Dockerfile)
* [`1.11.0`](https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/v1.11.0/Dockerfile)

### NOTE:

Apart from the aforementioned images, there are other images that contain `untested` as part of their tag. **Do not use these images.** As the tag suggests, they are present for purposes of testing. In order to test the images with `container-structure-test` and `trivy`, the image needs to be present in a public repository. Therefore, I first build and push the images with an `untested` tag. Then, I run tests on these images. When the image passes all tests, it is built again and pushed with the appropriate tags.



# Quick Reference

- **Maintained by** : [HarshaVardhanJ](https://github.com/HarshaVardhanJ/docker_files/)
- **Source of this description** : [README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/README.md)
- **Submit issues on** : [GitHub Issues](https://github.com/HarshaVardhanJ/docker_files/issues)  ![GitHub Issues](https://img.shields.io/github/issues/HarshaVardhanJ/docker_files)



# Software Packages Installed

The container image contains the following software packages installed as a dependency for Gitea, apart from the Gitea binary itself  

* `linux-pam`
* `bash`
* `git`
* `sqlite`
* `su-exec`
* `tzdata`



# Supported Architectures

Given below is a list of architectures for which Gitea has been built. In the near future, more architectures will be added.

* `amd64`
* `arm64`
* `arm32v7`



# Image Description

This is a container image of Gitea which is a lightweight self-hosted Git service. It can be hosted on low-powered devices like a Raspberry Pi which will be more than sufficient for a Git repository with one or two users. One of the advantages is that, for small installations, you do not need to run a database in a separate container as the basic image contains sqlite3 installed alongside Gitea. If intended for heavier usage, the installation can be configured with a dedicated database like MySQL or PostgreSQL in a separate container.


# Description of Tags

## `latest`, `1.11.4`, `1.11.3`, `1.11.2`, `1.11.1`, `1.11.0`

All these tags differ in only one way in that the tag corresponds to the release version of Gitea. For example, the tag `1.11.4` corresponds to the release version `1.11.4` of Gitea. Therefore, the only difference between the tags given above is the release version of Gitea.


# How to use this image

## Start a Gitea instance


A basic instance can be set up with the following one-liner command

```shell
$ docker container run -d --name gitea -p 2222:22 -p 8080:3000 -v /full/path/to/host/dir:/data harshavardhanj/gitea:latest
```

This will set up a basic instance of Gitea on your machine. Port 8080 has been connected to port 3000 on the container. So, in order to access the web server, you will need to open the URL `http://localhost:8080/` in order to access the installation screen. Also, create an empty directory so you can bind-mount it to Gitea. All your data will be saved in this directory. So if you need to terminate the instance and restart it, you can do so without any loss of data. You can just stop the container, which will leave your volume untouched. Later, you can run another instance of Gitea and bind-mount
the same volume in order to continue from where you left off.


## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yaml`/`docker-compose.yaml` for Gitea:

```yaml
version: "3.4"
services:
  gitea:
    image: harshavardhanj/gitea:1.11.0
    restart: always
    ports:
      - "8080:3000"
      - "2222:22"
    volumes:
      - gitea:/data
volumes:
  gitea:
    driver: local
```

[![Try in ‘Play With Docker’](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](https://labs.play-with-docker.com?stack=https://raw.githubusercontent.com/HarshaVardhanJ/docker_files/master/gitea/docker-compose.yaml)

**NOTE: The above Play With Docker example does not work. This has something to do with not being able to create volumes on the host.**

The above YAML file should be sufficient to set up a basic instance of Gitea. For more information, visit the [official Gitea documentation page](https://docs.gitea.io/en-us/install-with-docker/).



# License

As with all Docker images, these likely also contain other software which may be under other license (such as `bash`, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained.)

As for any pre-built image usage, it is the image user’s responsibility to ensure that any use of this image complies with any relevant licenses for all software container within.

The license for the code pertaining to the Docker container as given on my GitHub page is ![GitHub](https://img.shields.io/github/license/HarshaVardhanJ/docker_files).