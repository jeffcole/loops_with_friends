defmodule Loops.JamChannel do
  use Loops.Web, :channel

  alias Loops.Presence

  def join("jams:" <> jam_id, _params, socket) do
    send self(), :after_join

    {:ok,
     %{user_id: socket.assigns.user_id},
     assign(socket, :jam_id, String.to_integer(jam_id))}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user_id, %{
      loop_name: "80s_Back_Beat_01"
    })

    push socket, "presence_state", Presence.list(socket)

    {:noreply, socket}
  end
end
