# Elixir + Phoenix

FROM elixir:1.8.1

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Install node
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

RUN mkdir -p load_control
COPY load_control ./load_control

RUN mkdir -p /app
WORKDIR /app

COPY example_system/mix.exs example_system/mix.lock ./

RUN mkdir assets

COPY example_system/assets/package.json assets
COPY example_system/assets/package-lock.json assets

RUN mix deps.get && \
  cd assets && \
  npm install && \
  cd .. && \
  mix compile

COPY example_system /app
