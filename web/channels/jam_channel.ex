defmodule Loops.JamChannel do
  use Loops.Web, :channel

  alias Loops.Presence

  intercept ["loop:played", "loop:stopped"]

  def join("jams:" <> jam_id, _params, socket) do
    send self(), :after_join

    {:ok,
     %{user_id: socket.assigns.user_id},
     assign(socket, :jam_id, String.to_integer(jam_id))}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user_id, %{
      user_id: socket.assigns.user_id,
      loop_name: "80s_Back_Beat_01"
    })

    push socket, "presence_state", Presence.list(socket)

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
end
