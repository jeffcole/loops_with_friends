defmodule LoopsWithFriends.JamChannel do
  @moduledoc """
  Hosts jams for users.
  """

  use LoopsWithFriends.Web, :channel

  alias LoopsWithFriends.JamBalancer
  alias LoopsWithFriends.LoopCycler
  alias LoopsWithFriends.Presence

  intercept ["loop:played", "loop:stopped"]

  def join("jams:" <> jam_id, _params, socket) do
    send self(), :after_join

    {:ok,
     %{user_id: socket.assigns.user_id},
     assign(socket, :jam_id, jam_id)}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user_id, %{
      user_id: socket.assigns.user_id,
      loop_name: LoopCycler.next_loop
    })

    presence_list = Presence.list(socket)
    JamBalancer.refresh(socket.assigns.jam_id, presence_list)

    push socket, "presence_state", presence_list

    {:noreply, socket}
  end

  def handle_in("loop:" <> event, %{"user_id" => user_id}, socket) do
    broadcast! socket, "loop:#{event}", %{user_id: user_id}

    {:noreply, socket}
  end

  def handle_out("loop:" <> event, message, socket) do
    unless socket.assigns.user_id == message.user_id do
      push socket, "loop:#{event}", message
    end

    {:noreply, socket}
  end

  def terminate(msg, socket) do
    JamBalancer.remove_user(socket.assigns.jam_id, socket.assigns.user_id)

    msg
  end
end
