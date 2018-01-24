# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Retro.Repo.insert!(%Retro.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Retro.Repo.insert!(%Retro.Room{name: "Dev Retro", password: "bethcatlover"})
Retro.Repo.insert!(%Retro.Room{name: "Accounting Retro", password: "bethcatlover"})
Retro.Repo.insert!(%Retro.Room{name: "All hands Retro", password: "bethcatlover"})
