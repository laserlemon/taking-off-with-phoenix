defmodule Workshop.RegistrationController do
  use Workshop.Web, :controller

  alias Workshop.User

  def new(conn, _params) do
    changeset = User.new_changeset(%User{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.validated_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Great success!")
        |> put_session(:current_user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "I've made a huge mistake.")
        |> render("new.html", changeset: changeset)
    end
  end
end
