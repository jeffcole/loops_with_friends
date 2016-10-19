defmodule LoopsWithFriends.JamChannelTest do
  use LoopsWithFriends.ChannelCase, async: true

  setup do
    {:ok, socket} = connect(LoopsWithFriends.UserSocket, %{})

    {:ok, socket: socket}
  end

  describe "`join`" do
    test "replies with a `user_id`", %{socket: socket} do
      {:ok, reply, _socket} = subscribe_and_join(socket, "jams:jam-1", %{})

      assert %{user_id: user_id} = reply
      assert user_id
    end

    test "assigns the `jam_id`", %{socket: socket} do
      socket = subscribe_and_join!(socket, "jams:jam-1", %{})

      assert socket.assigns.jam_id == "jam-1"
    end

    test "pushes presence state", %{socket: socket} do
      {:ok, _reply, _socket} = subscribe_and_join(socket, "jams:jam-1", %{})

      assert_push "presence_state", %{}
    end
  end

  describe "`join` given a full jam" do
    test "returns an error and a new jam", %{socket: socket} do
      join_response = subscribe_and_join(socket, "jams:full-jam", %{})

      assert {:error, reply} = join_response
      assert %{new_topic: topic} = reply
      assert topic != "jams:full-jam"
    end
  end

  # To test this, we would need to populate the presence, which I don't know
  # how to do from tests.
  @tag :skip
  describe "`join` when all loops are present" do
    test "returns an error and a new jam", %{socket: socket} do
      join_response = subscribe_and_join(socket, "jams:jam-1", %{})

      assert {:error, reply} = join_response
      assert %{new_topic: topic} = reply
      assert topic != "jams:jam-1"
    end
  end

  describe "`handle_in` given a loop event" do
    test "broadcasts the event", %{socket: socket} do
      socket = subscribe_and_join!(socket, "jams:jam-1", %{})
      user_id = socket.assigns.user_id

      push socket, "loop:played", %{"user_id" => user_id}

      assert_broadcast "loop:played", %{user_id: ^user_id}
    end
  end

  describe "`handle_out` given a loop event" do
    test "pushes events to channel subscribers", %{socket: socket} do
      subscribe_and_join!(socket, "jams:jam-1", %{})

      {:ok, socket_2} = connect(LoopsWithFriends.UserSocket, %{})
      {:ok, _reply, socket_2} = join(socket_2, "jams:jam-1")
      user_2 = socket_2.assigns.user_id

      push socket_2, "loop:played", %{"user_id" => user_2}

      assert_push "loop:played", %{user_id: ^user_2}
    end

    test "does not push events to the message sender", %{socket: socket} do
      socket = subscribe_and_join!(socket, "jams:jam-1", %{})

      push socket, "loop:played", %{"user_id" => socket.assigns.user_id}

      refute_push "loop:played", _payload
    end
  end
end
