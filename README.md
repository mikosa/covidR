# covidR

to build the container:
'''
docker build . -t covid19
'''


# to run the container and test the code
'''
docker run -it -v /mnt/c/Users/sabba/code/covid19-R:/home/docker/script covid19 bash
docker run -it -v /home/ec2-user/environment/covidR:/home/docker/script covid19 bash
'''

# then run inside the container 
'''
Rscript rscript.r
