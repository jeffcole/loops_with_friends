defmodule LoopsWithFriends.JamChannel do
  @moduledoc """
  Hosts jams for users.
  """

  use LoopsWithFriends.Web, :channel

  alias LoopsWithFriends.{LoopCycler, Presence}

  @jam_balancer Application.get_env(:loops_with_friends, :jam_balancer)

  intercept ["loop:played", "loop:stopped"]

  def join("jams:" <> jam_id, _params, socket) do
    if !@jam_balancer.jam_full?(jam_id) do
      Presence.track(socket, socket.assigns.user_id, %{
        user_id: socket.assigns.user_id,
        loop_name: LoopCycler.next_loop(present_loops(socket))
      })

      @jam_balancer.refresh(jam_id, Presence.list(socket))

      send self(), :after_join

      {:ok,
       %{user_id: socket.assigns.user_id},
       assign(socket, :jam_id, jam_id)}
    else
      {:error, %{new_topic: "jams:#{@jam_balancer.current_jam}"}}
    end
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    {:noreply, socket}
  end

  def handle_in("loop:" <> event, %{"user_id" => user_id}, socket) do
    update_presence(socket, user_id, event)

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
    @jam_balancer.remove_user(socket.assigns.jam_id, socket.assigns.user_id)

    msg
  end

  defp update_presence(socket, user_id, event) do
    Presence.update(
      socket,
      user_id,
      put_in(user_meta(socket, user_id)[:loop_event], event)
    )
  end

  defp user_meta(socket, user_id) do
    hd(Presence.list(socket)[user_id][:metas])
  end

  defp present_loops(socket) do
    socket
    |> Presence.list
    |> Presence.extract_loops
  end
end
