FROM r-base

# this is needed to install XML package
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev libxml2-dev 
RUN apt-get update -qq && apt-get install -y \
    git-core \
    libssl-dev \
    libcurl4-gnutls-dev
RUN apt -y install gdebi-core

# install extra packages
# COPY R0/ /home/docker/R0
# COPY XML/ /home/docker/XML
# COPY jsonlite/ /home/docker/jsonlite
#COPY shiny/ /home/docker/shiny
# RUN R -e "install.packages('R0')"
# RUN R -e "install.packages('XML')"
# RUN R -e "install.packages('jsonlite')"
RUN install2.r plumber
# RUN R -e "install.packages('plumber', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('EpiEstim', repos='https://cran.rstudio.com/')"
COPY . /home/docker/script
# start from home/docker
WORKDIR /home/docker/script/
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('plumber.R'); pr$run(host='0.0.0.0', port=8080)"]

