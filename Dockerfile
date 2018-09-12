FROM ubuntu:18.04
MAINTAINER Danny Flack <flackattack@gmail.com>

RUN apt-get update && apt-get install -y \
	python python3 python3-venv \
	build-essential \
	wget \
	vim \
	curl \
	git \
	nodejs \
	supervisor \
	&& true

# install cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh
# listen on all interfaces
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

RUN apt-get install -y npm

# clean up apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install angular cli globally
RUN npm install -g @angular/cli

# add volumes
RUN mkdir /workspace
VOLUME /workspace

# expose ports
EXPOSE 80
EXPOSE 3000

ENTRYPOINT ["node", "server.js", "--listen", "0.0.0.0", "--port", "80", "-w", "/workspace"]
