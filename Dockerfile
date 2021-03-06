# ./Dockerfile
# Elixir base image to start with
FROM elixir:1.9

# install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

# install the latest Phoenix version
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# install NodeJS and NPM
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs
RUN apt-get install -y inotify-tools

# create our app folder, copy our code in it and set it as the default app
RUN mkdir /app
COPY . /app
WORKDIR /app

# install dependencies
RUN mix deps.get
RUN mix deps.compile

# install the assets.
# we can't separate the command as each command crate a temporary container
# and each container as it own temporary variables, making each individual command fail.
RUN cd assets && npm install && npm run build && cd ../ && mix phx.digest

# run the phoenix server. The CMD is run each time the container is launched.
CMD mix phx.server
