# docker build -t standalone_embed .
# docker image ls
# docker run -p 80:5006 standalone_embed

# List all containers (only IDs) docker ps -aq.
# Stop all running containers. docker stop $(docker ps -aq)
# Remove all containers. docker rm $(docker ps -aq)
# Remove all images. docker rmi $(docker images -q)


FROM continuumio/miniconda3

# Set the ENTRYPOINT to use bash
# (this is also where you’d set SHELL,
# if your version of docker supports this)
ENTRYPOINT [ “/bin/bash”, “-c” ]

EXPOSE 5006

COPY . /
WORKDIR /

# Conda supports delegating to pip to install dependencies
# that aren’t available in anaconda or need to be compiled
# for other reasons. In our case, we need psycopg compiled
# with SSL support. These commands install prereqs necessary
# to build psycopg.
RUN apt-get update && apt-get install -y \
 libpq-dev \
 build-essential \
&& rm -rf /var/lib/apt/lists/*

# Install pyviz
# http://pyviz.org/installation.html

# update conda
RUN conda update conda
RUN conda update conda


# install flask and Bokeh

RUN conda install -c conda-forge bokeh
RUN conda install -c anaconda flask
RUN conda install -c anaconda pandas



# We set ENTRYPOINT, so while we still use exec mode, we don’t
# explicitly call /bin/bash
ENTRYPOINT ["python", "./standalone_embed.py"]

# https://github.com/lukauskas/docker-bokeh
# https://github.com/bokeh/bokeh/issues/7724
