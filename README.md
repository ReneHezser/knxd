# KNXD Dockerfile


This repository contains **Dockerfile** of KNXD.

## Docker Image

* The image uses [ubuntu](https://hub.docker.com/_/ubuntu) 20.04 as base image
* The tag matches the tag of the [knxd repository](https://github.com/knxd/knxd/tags). In addition to that tag, the "latest" tag and an increasing number is added to each image.
* dependabot checks for an update base image


## Installation
1. Install [Docker](https://www.docker.com/).
2. Download: `docker pull renehezser/knxd`
3. Create a local container (see usage below)

## Usage

    docker run -d -p 0.0.0.0:6720:6720 -v /path/to/config.ini:/another/path/to/config.ini renehezser/knxd /another/path/to/config.ini

### config.ini

config.ini file documentation can be found on the KNXD site: 
[config documentantion](https://github.com/knxd/knxd/blob/master/doc/inifile.rst)

### docker-compose
A sampe docker-compose.yml could look like this and will map your custom config.ini into the container.

```yaml
version: '3.4'
services:
  knxd:
    image: renehezser/knxd
    container_name: knxd
    volumes:
      - /mnt/knxd/config.ini:/config.ini
    ports:
      - 6720:6720
      - 3671:3671
    restart: always
    network_mode: host
```

## Building the image
The images are build automatically with GitHub actions. If you want to build the image yourself, you can build an image from the Dockerfile: `docker build -t="renehezser/knxd" github.com/renehezser/knxd`

*the reference to [act](https://github.com/nektos/act) in the docker-image.yaml file is to run GitHub actions locally and not uploading the result to docker hub*

## Changelog

- 0.14.53: knxd update

## TODO
- create a new image when knxd releases a new version