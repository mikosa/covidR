FROM us.gcr.io/olibato-1543680389483/covid19base
COPY . /home/docker/script
# start from home/docker
WORKDIR /home/docker/script/
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('plumber.R'); pr$run(host='0.0.0.0', port=8080)"]