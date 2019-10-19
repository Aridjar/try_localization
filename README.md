# Localization

To start your Phoenix server:

## Without docker

  * Install dependencies with `mix deps.get`
  * Update either your env or `config/dev.exs`and `config/test.exs` to match your database (env is prefered)
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## With docker

  * Duplicate `.env.dist` to `.env` and update the values inside it
  * Build the image with `docker-compose build`
  * Launch the postgres container `docker-compose up -d postgres`
  * Get the container ID `docker ps`
  * Get the container IP `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [container_ID]`
  * Update your .env with the IP (put it in the `host` parameter)
  * Launch the elixir's container `docker-compose up -d elixir`
  * Create and migrate your database with `docker-compose exec elixir mix ecto.setup`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
