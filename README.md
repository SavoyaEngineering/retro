# Retro

## Setup Machine
Install elixir. Using 1.6.0, phoenix needs > 1.4.
```apple js
brew update
brew install elixir
```
https://elixir-lang.org/install.html

Install Phoenix. Using 1.3.0.
```apple js
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez
```
https://hexdocs.pm/phoenix/installation.html

Clone the repo and move to the directory and setup the app/ db.
```apple js
mix deps.get
mix ecto.create
mix exto.migrate
cd assets && npm install
```
https://hexdocs.pm/phoenix/up_and_running.html

You can seed the db if you wish with
```apple js
mix run priv/repo/seeds.exs
```


## Running server

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`
  * You can also run your app inside IEx (Interactive Elixir) as `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## App console
To get into repl with the app loaded, run;
```apple js
alias Retro.{Repo, Room}
```

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Tests
To run specs;
```apple js
mix test
```
