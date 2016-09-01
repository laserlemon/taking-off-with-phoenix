defmodule Workshop.CurrentUser do
  import Plug.Conn

  alias Workshop.{Repo,User}

  def current_user(conn, _opts) do
    user = case get_session(conn, :current_user_id) do
      nil -> nil
      id -> Repo.get(User, id)
    end

    # assign conn, :current_user, user
    # assign conn, :logged_in?, !!user

    conn
    |> assign(:current_user, user)
    |> assign(:logged_in?, !!user)
  end
end
