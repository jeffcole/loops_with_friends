ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Loops.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Loops.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Loops.Repo)

