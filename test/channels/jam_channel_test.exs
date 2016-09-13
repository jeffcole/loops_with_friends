defmodule LoopsWithFriends.JamChannelTest do
  use LoopsWithFriends.ChannelCase, async: true

  setup do
    {:ok, socket} = connect(LoopsWithFriends.UserSocket, %{})

    {:ok, socket: socket}
  end

  describe "`.join`" do
    test "replies with a `user_id`", %{socket: socket} do
      {:ok, reply, _socket} = subscribe_and_join(socket, "jams:1", %{})

      assert %{user_id: user_id} = reply
      assert user_id
    end

    test "assigns the `jam_id`", %{socket: socket} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "jams:1", %{})

      assert socket.assigns.jam_id == "1"
    end

    test "pushes presence state", %{socket: socket} do
      {:ok, _reply, _socket} = subscribe_and_join(socket, "jams:1", %{})

      assert_push "presence_state", %{}
    end
  end

  describe "`.handle_in` given a loop event" do
    test "broadcasts the event", %{socket: socket} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "jams:1", %{})

      push socket, "loop:played", %{"user_id" => "123"}

      assert_broadcast "loop:played", %{user_id: "123"}
    end
  end

  describe "`.handle_out` given a loop event" do
    test "pushes events to channel subscribers", %{socket: socket} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "jams:1", %{})

      push socket, "loop:played", %{"user_id" => "123"}

      assert_push "loop:played", %{user_id: "123"}
    end

    test "does not push events to the message sender", %{socket: socket} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "jams:1", %{})

      push socket, "loop:played", %{"user_id" => socket.assigns.user_id}

      refute_push "loop:played", _payload
    end
  end
end
