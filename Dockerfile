FROM r-base

# this is needed to install XML package
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev libxml2-dev

# install extra packages
COPY R0/ /home/docker/R0
COPY XML/ /home/docker/XML
RUN R -e "install.packages('R0')"
RUN R -e "install.packages('XML')"

# start from home/docker
WORKDIR /home/docker
