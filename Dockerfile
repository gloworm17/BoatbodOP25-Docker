FROM debian:bookworm-slim
LABEL desc="boatbod/op25"
ENV DEBIAN_FRONTEND=noninteractive
ARG TZ=America/New_York
RUN cd /
RUN export DEBIAN_FRONTEND=noninteractive && \
    export TZ=$TZ && \
    apt-get update && apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata
#Get basic support for scripts
RUN apt-get update && apt-get install -y git sudo python3
#Get OP25 and (Yes) to install
RUN git clone --branch gr310 https://github.com/boatbod/op25 && cd ./op25 && yes | ./install.sh
#Set our working directory
WORKDIR "/op25/op25/gr-op25_repeater/apps"
#Copy wav and sample config
COPY 2021-04-17@222644.WAV .
COPY activeconfig.json .
#Specify default config values
ENV config activeconfig.json
#Expose OP25 Web GUI
EXPOSE 8080
#Expose audio
EXPOSE 23446
#Expose Icecast Port (Probably not needed if info is outbound)
#EXPOSE 8000
CMD python3 multi_rx.py -c ${config}