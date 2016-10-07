defmodule LoopsWithFriends.JamCollection.Stub do
  @moduledoc """
  Provides a subbed jam collection API for use in testing.
  """

  @behaviour LoopsWithFriends.JamCollection

  def new(opts \\ []) do
    opts = Keyword.put_new(opts, :caller, self())
    send opts[:caller], :called_jam_collection_new

    %{}
  end

  def refresh(_jams, _jam_id, ["user-1"], opts \\ []) do
    opts = Keyword.put_new(opts, :caller, self())

    send opts[:caller], :called_jam_collection_refresh
  end

  def most_populated_jam_with_capacity_or_new(_jams) do
    send self(), :called_jam_collection_most_populated_jam_with_capacity_or_new
  end

  def jam_capacity?(jams, _jam_id) when jams == %{} do
    send self(), :called_jam_collection_jam_capacity?
  end

  def remove_user(_jams, _jam_id, _user_id, opts \\ []) do
    opts = Keyword.put_new(opts, :caller, self())

    send opts[:caller], :called_jam_collection_remove_user
  end
end
