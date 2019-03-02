FROM ruby:2.5.3
# Install VIM to edit credentials.yml.enc file
RUN apt-get update && apt-get install -y vim
ENV EDITOR="vim"
# Install container dependencies
RUN apt-get update && apt-get install -y libc-ares2 libv8-3.14.5 postgresql-client sqlite nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
# Install Chrome to use with Capybara JavaScript specs
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable
# Set the work directory inside container
RUN mkdir /app
WORKDIR /app
# Copy the Gemfile inside the container
COPY bulldozer.gemspec /app/
COPY Gemfile* /app/
# Copy all the rest inside work directory
COPY . /app
# Go inside the /app folder, without this you have problems with relative paths
RUN cd /app
# Install dependencies
RUN gem install bundler
RUN bundle install --jobs 32 --retry 4