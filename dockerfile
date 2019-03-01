FROM ruby:2.5.3
# Install VIM to edit credentials.yml.enc file
RUN apt-get update && apt-get install -y vim
ENV EDITOR="vim"
# Install container dependencies
RUN apt-get update && apt-get install -y libc-ares2 libv8-3.14.5 --no-install-recommends && rm -rf /var/lib/apt/lists/*
# Set the work directory inside container
RUN mkdir /app
WORKDIR /app
# Copy all the rest inside work directory
COPY . /app