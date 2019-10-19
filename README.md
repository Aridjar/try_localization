# Localization

The project is in Elixir.

Go would have probably be the best language to do this project, as it is fast (which is a requirement of the second part), easy to create API with (third part), and is an iterative language.</br>
Unfortunatly, time is also a constraint. As I almost don't know Go (nor its libs, just that it isn't really easy to use external depencies (even if it got better)), I didn't want spend too much time trying to figure out Go instead of the actual problem.

That's why Elixir was my choice: I know it, I can setup an API in a short time, find libs easely and the documentation is one of the best. It is great for the second and third part.
Unfortunatly, the first part will be longer than with an OOP langage (at equal knowledge).

Test should fully cover the code.</br>
The documentation is made in the module level (not function level).


# To start your Phoenix server:

## Without docker

  * Install dependencies with `mix deps.get`
  * Update either your env or `config/dev.exs`and `config/test.exs` to match your database (env is prefered)
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
To test the script, you can also launch `iex -S mix` and call the function `Localization.ImportCsv.do_script()`
You can run tests with `mix test`

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
To test the script, you can also launch `docker-compose exec elixir iex -S mix` and call the function `Localization.ImportCsv.do_script()`
You can run tests with `docker-compose exec elixir mix test`

## Coordinates calculs

I should have asked for coordinate before the week-end. Unfortunately, I was focused on other task, and when I spend a little time organizing the project, I didn't do enough research to figure out it would have been a problem.
I could have use external databse, but the one I found are about country, not continents, which create a problem for the second part (and force the use of a databse).
There is also external API which could be helpfull, but the number of call is limited, and with a large file I would probably not be able to do as many tests as I want.

Which lead to the "in house" solution, where we use one dependencies and data stored in the code: (You can find the sources of the coordinates here)

Africa: [Liste de points extrêmes de l'Afrique](https://fr.wikipedia.org/wiki/Liste_de_points_extrêmes_de_l%27Afrique)
Antartiqua: [Liste de points extrêmes de l'Antarctique](https://fr.wikipedia.org/wiki/Liste_de_points_extrêmes_de_l%27Antarctique)
Asia: [Liste de points extrêmes de l'Asie](https://fr.wikipedia.org/wiki/Liste_de_points_extrêmes_de_l%27Asie)
Europe: [Liste de points extrêmes de l'Europe](https://fr.wikipedia.org/wiki/Liste_de_points_extrêmes_de_l%27Europe) 
Oceania [Liste de points extrêmes de l'Océanie](https://fr.wikipedia.org/wiki/Liste_de_points_extrêmes_de_l%27Océanie)
America (south and north): [Liste de points extrêmes de l'Amérique](https://fr.wikipedia.org/wiki/Liste_de_points_extrêmes_de_l%27Amérique)

# 02/03 : Questions : Scaling

There is multiple methods for scaling. As the langage is already performant, it wouldn't be usefull to change it. (Go would have been another solution, and Java/C++ could potentially be acceptable).

To scale, you could
* Improve your postgresQL (which should have the module PostGIS to direclty ask for continent in the database) with better caching, better index and [optimization](https://gist.github.com/valyala/ae3cbfa4104f1a022a2af9b8656b1131)
* Create SQL cluster. This may ask for a lot of money and DevOps knowledge.
* Create a Redis with id in the format `category:continent` which should only store a number. This should be simple to implement, but it would only be usefull for the one thing it was design for, and literally nothing else.
* Use `Agent` to store the data instead of Redis. It can only be done in a Elixir/Erlang project.
* Store the database calls and `Copy` the new jobs each seconds. This would make the write take less time, but people may miss some data, as they aren't persisted in real time. (but, what is a seconds ?)
