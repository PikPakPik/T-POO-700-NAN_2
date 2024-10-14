FROM elixir:latest

RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client && \
    apt-get clean

ADD . /app
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.7.14


ENV MIX_ENV=prod

RUN mix deps.get --only prod
RUN mix compile
RUN env

EXPOSE 4000

CMD ["./entrypoint.sh"]
