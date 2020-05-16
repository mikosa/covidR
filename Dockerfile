FROM r-base

# this is needed to install XML package
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev libxml2-dev
RUN apt -y install gdebi-core

# install extra packages
COPY R0/ /home/docker/R0
COPY XML/ /home/docker/XML
COPY jsonlite/ /home/docker/jsonlite
#COPY shiny/ /home/docker/shiny
RUN R -e "install.packages('R0')"
RUN R -e "install.packages('XML')"
RUN R -e "install.packages('jsonlite')"
RUN R -e "install.packages('plumber', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('EpiEstim', repos='https://cran.rstudio.com/')"
# start from home/docker
WORKDIR /home/docker/script/