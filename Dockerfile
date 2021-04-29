# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client gcc g++ make curl gnupg build-essential

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force

# Install Node npm packages
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y install nodejs
RUN cd assets && npm install

# Compile the project
RUN mix do compile

CMD ["/app/entrypoint.sh"]