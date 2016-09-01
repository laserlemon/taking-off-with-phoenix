defmodule Workshop.SessionController do
  use Workshop.Web, :controller

  alias Workshop.Login

  def new(conn, _params) do
    changeset = Login.new_changeset(%Login{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"login" => login_params}) do
    changeset = Login.validated_changeset(%Login{}, login_params)

    if changeset.valid? do
      conn
      |> put_flash(:info, "Welcome back!")
      |> put_session(:current_user_id, changeset.changes.user_id)
      |> redirect(to: page_path(conn, :index))
    else
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
