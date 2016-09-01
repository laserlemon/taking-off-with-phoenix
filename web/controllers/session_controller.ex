defmodule Workshop.SessionController do
  use Workshop.Web, :controller

  alias Workshop.User

  def new(conn, _params) do
    changeset = User.login_changeset(%User{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.login_changeset(%User{}, user_params)

    if changeset.valid? do
      conn
      |> put_flash(:info, "Welcome back!")
      |> put_session(:current_user_id, changeset.changes.id)
      |> redirect(to: page_path(conn, :index))
    else
      # FIXME: This can't be right.
      changeset = Map.put(changeset, :action, :insert)

      conn
      |> put_flash(:error, "NOPE!")
      |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_session(:current_user_id, nil)
    |> redirect(to: page_path(conn, :index))
  end
end
