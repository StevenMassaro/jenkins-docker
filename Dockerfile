from jenkins/jenkins:lts
 
USER root
RUN apt-get update -qq \
 && apt-get install apt-transport-https -yq \
 ca-certificates \
 curl \
 software-properties-common \
 sudo

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" \
    && sudo apt-get update \
    && sudo apt-get install docker-ce=5:18.09.5~3-0~ubuntu-xenial containerd.io=1.2.2-3 -yq

# Install Ruby and Jekyll
RUN \
  apt-get update && apt-get install -y --no-install-recommends --no-install-suggests curl bzip2 build-essential libssl-dev libreadline-dev zlib1g-dev && \
  rm -rf /var/lib/apt/lists/* && \
  curl -L https://github.com/sstephenson/ruby-build/archive/v20180329.tar.gz | tar -zxvf - -C /tmp/ && \
  cd /tmp/ruby-build-* && ./install.sh && cd / && \
  ruby-build -v 2.5.1 /usr/local && rm -rfv /tmp/ruby-build-* && \
  gem install jekyll bundler --no-rdoc --no-ri
  	
# Install ImageMagick (for Jekyll picture resizing)
RUN apt-get update && apt-get install --assume-yes imagemagick

# Install rclone (for uploading artifacts to S3)
RUN apt-get install rclone

# Install xpath for blog build
RUN apt-get install --assume-yes libxml-xpath-perl
