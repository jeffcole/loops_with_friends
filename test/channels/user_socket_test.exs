defmodule LoopsWithFriends.UserSocketTest do
  use LoopsWithFriends.ChannelCase, async: true

  alias LoopsWithFriends.UserSocket

  test "`.connect` assigns a UUID" do
    assert {:ok, socket} = connect(UserSocket, %{})

    assert UUID.info!(socket.assigns.user_id)
  end
end
