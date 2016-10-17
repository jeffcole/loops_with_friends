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

  describe "`refresh`" do
    setup :start_server

    test "refreshes a jam with the keys of a map" do
      result = Server.refresh(
        @name,
        "jam-1",
        %{"user-1" => :data},
        caller: self()
      )

      assert :ok = result
      assert_receive :called_jam_collection_refresh
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

  describe "`jam_capacity?`" do
    setup :start_server

    test "delegates to the collection" do
      Server.jam_capacity?(@name, "jam-1")

      assert_receive :called_jam_collection_jam_capacity?
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
    Server.start_link(name: @name)

    context
  end
end
