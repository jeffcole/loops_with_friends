defmodule Loops.JamChannel do
  use Loops.Web, :channel

  def join("jams:" <> jam_id, _params, socket) do
    {:ok, assign(socket, :jam_id, String.to_integer(jam_id))}
  end
end
