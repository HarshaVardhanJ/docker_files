# `binfmt` Docker Image

# [![](https://images.microbadger.com/badges/version/harshavardhanj/binfmt.svg)](https://microbadger.com/images/harshavardhanj/binfmt "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/harshavardhanj/binfmt.svg)](https://microbadger.com/images/harshavardhanj/binfmt "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/license/harshavardhanj/binfmt.svg)](https://microbadger.com/images/harshavardhanj/binfmt "Get your own license badge on microbadger.com")
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshavardhanj/binfmt/stable)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/harshavardhanj/binfmt/stable)
![Docker Pulls](https://img.shields.io/docker/pulls/harshavardhanj/binfmt)

In case you find this image to be useful, please consider clicking the link below to say thanks! Thank you.  
[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/vardhanharshaj%40gmail.com)

# Supported tags and respective `Dockerfile` links

* [`latest`, `stable`](https://github.com/HarshaVardhanj/docker_files/blob/master/binfmt/Dockerfile)
* [`testing`](https://github.com/HarshaVardhanJ/docker_files/blob/testing/binfmt/Dockerfile)

### NOTE:

Apart from the aforementioned images, there are other images that contain `untested` as part of their tag. **Do not use these images.** As the tag suggests, they are present for purposes of testing. In order to test the images with `container-structure-test` and `trivy`, the image needs to be present in a public repository. Therefore, I first build and push the images with an `untested` tag. Then, I run tests on these images. When the image passes all tests, it is built again and pushed with the appropriate tags.



# Quick Reference

- **Maintained by** : [HarshaVardhanJ](https://github.com/HarshaVardhanJ/docker_files/)
- **Source of this description** : [README in `docker_files` repository](https://github.com/HarshaVardhanJ/docker_files/blob/master/binfmt/README.md)
- **Submit issues on** : [GitHub Issues](https://github.com/HarshaVardhanJ/docker_files/issues)  ![GitHub Issues](https://img.shields.io/github/issues/HarshaVardhanJ/docker_files)



# Software Packages Installed

This image contains the following binaries

* `binfmt`
* `qemu-aarch64`
* `qemu-arm` 
* `qemu-armeb`
* `qemu-i386`
* `qemu-ppc64le`
* `qemu-s390x`

and the following file

* `00_linuxkit.conf`

added to the `scratch` base image. From a security standpoint, one does not have to worry about exploits or vulnerabilities(apart from any present in the `qemu` binaries) as the `scratch` base image is used(no OS). Apart from the aforementioned binaries and configuration file, no other files are present on the image.



# Supported Architectures

* `amd64`
* `arm64`
* `ppc64le`
* `i386`
* `s390x`



# Image Description

This image is used to enable `binfmt` support in order to help build multi-architecture container images. Using this, one can leverage the capabilties of `buildx` in Docker in order to build container images for multiple architectures without having to make any changes to the `Dockerfile`.



# Description of Tags

## `latest`, `stable`

The images with the `latest` tag and `stable` tag are, for all intents and purposes, the same. As description of what is present in the image is given in the *Software Package Installed* section.

## `testing`

This image differs in the way that any new features or changes will first be introduced under this tag. Only after extensive usage and testing will the image be graduated to the `stable`/`testing` tag. It is inadvisable to images with this tag unless you want some new feature that has not yet been implemented in the `stable`/`latest` tag.



# How to use this image

Register the `binfmt` image by running the following command on the machine that has Docker installed.

```shell
$ docker run --rm --privileged harshavardhanj/binfmt:stable
```

Then, get the `qemu-user-static` binary by running the following command.

```sh
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Now, you can build multi-architecture images using the `buildx` utility in Docker.
The command given below illustrates this:

```sh
$ docker buildx build -t [repository_name]/[image_name]:[image_tag] --platform \
linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 -f [path/to/Dockerfile] \ [/path/to/directory/containing/Dockerfile/.]
```

> NOTE: 
>
> The last argument to the `buildx` command **must** be the ‘build context’ which is the path to the directory that contains the Dockerfile. The path is supposed to end with a period(`.`) as can be seen in the aforementioned command. 

This way, the `binfmt` image can be used to build multi-arch images.



# Variants

The `binfmt` image comes in only one variant, which comes in three tags(`stable`, `latest`, and `testing`). All of them are built on top of the `scratch` base image.



# License

As with all Docker images, these likely also contain other software which may be under other license (such as `bash`, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained.)

As for any pre-built image usage, it is the image user’s responsibility to ensure that any use of this image complies with any relevant licenses for all software container within.

