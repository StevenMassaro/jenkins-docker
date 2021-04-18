from jenkins/jenkins:lts
 
USER root
# rclone - for copying files in blog job
# libxml-xpath-perl - for parsing html in blog job
# libvips-dev - for generating images in blog job
RUN apt-get update -qq \
 && apt-get install apt-transport-https -yq \
 ca-certificates \
 curl \
 software-properties-common \
 sudo \
 rclone \
 libxml-xpath-perl \
 libvips-dev

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" \
    && sudo apt-get update \
    && sudo apt-get install docker-ce=5:18.09.5~3-0~ubuntu-xenial containerd.io=1.2.2-3 -yq

# Install Ruby and Jekyll
RUN \
  apt-get update && apt-get install -y --no-install-recommends --no-install-suggests curl bzip2 build-essential libssl-dev libreadline-dev zlib1g-dev && \
  rm -rf /var/lib/apt/lists/* && \
  curl -L https://github.com/rbenv/ruby-build/archive/refs/tags/v20210405.tar.gz | tar -zxvf - -C /tmp/ && \
  cd /tmp/ruby-build-* && ./install.sh && cd / && \
  ruby-build -v 2.7.3 /usr/local && rm -rfv /tmp/ruby-build-* && \
  gem install jekyll bundler --no-document
