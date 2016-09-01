defmodule Workshop.Login do
  use Workshop.Web, :model

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  @allowed_fields ~w(email password)a
  @required_fields @allowed_fields

  def new_changeset(login, params \\ %{}) do
    login
    |> cast(params, @allowed_fields)
  end

  def validated_changeset(login, params) do
    new_changeset(login, params)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> check_password()
  end

  defp check_password(%{valid?: false} = changeset), do: changeset
  defp check_password(%{changes: %{email: email, password: password}} = changeset) do
    user = Workshop.Repo.get_by(Workshop.User, email: email)

    if user do
      if Comeonin.Bcrypt.checkpw(password, user.hashed_password) do
        put_change changeset, :user_id, user.id
      else
        add_error changeset, :password, "is incorrect"
      end
    else
      add_error changeset, :email, "cannot be found"
    end
  end
end
