defmodule LoopsWithFriends.DatabaseCase do
  @moduledoc """
  This module defines the test case to be used by tests that require a database
  connection.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias LoopsWithFriends.Repo

      import LoopsWithFriends.DatabaseCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(LoopsWithFriends.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(LoopsWithFriends.Repo, {:shared, self()})
    end

    :ok
  end
end
