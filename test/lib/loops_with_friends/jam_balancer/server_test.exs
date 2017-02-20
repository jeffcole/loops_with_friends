defmodule LoopsWithFriends.JamBalancer.ServerTest do
  use ExUnit.Case, async: true

  alias LoopsWithFriends.JamBalancer.Server

  @name __MODULE__

  describe "`start_link`" do
    test "starts a new jam collection" do
      result = Server.start_link(name: @name, caller: self())

      assert {:ok, _pid} = result
      assert_receive :called_jam_collection_new
    end
  end

  describe "`add_user`" do
    setup :start_server

    test "delegates to the collection" do
      result = Server.add_user(@name, "jam-1", "user-1", caller: self())

      assert :ok = result
      assert_receive :called_jam_collection_add_user
    end

    test "returns an error for a full jam" do
      result = Server.add_user(@name, "full-jam", "user-1", caller: self())

      assert :error = result
      assert_receive :called_jam_collection_add_user
    end
  end

  describe "`current_jam`" do
    setup :start_server

    test "delegates to the collection" do
      Server.current_jam(@name)

      assert_receive(
        :called_jam_collection_most_populated_jam_with_capacity_or_new
      )
    end
  end

  describe "`remove_user`" do
    setup :start_server

    test "delegates to the collection" do
      result = Server.remove_user(
        @name,
        "jam-1",
        "user-1",
        caller: self()
      )

      assert :ok = result
      assert_receive :called_jam_collection_remove_user
    end
  end

  describe "`stats`" do
    setup :start_server

    test "delegates to the collection" do
      Server.stats(@name)

      assert_receive :called_jam_collection_stats
    end
  end

  defp start_server(context) do
    Server.start_link(name: @name, caller: self())

    context
  end
end
