defmodule LoopsWithFriends.PageView do
  use LoopsWithFriends.Web, :view

  def current_jam do
    Application.get_env(:loops_with_friends, :jam_balancer).current_jam
  end
end
