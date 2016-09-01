defmodule Workshop.User do
  use Workshop.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :hashed_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  @allowed_fields ~w(name email password password_confirmation)a
  @required_fields @allowed_fields

  def new_changeset(user, params \\ %{}) do
    user
    |> cast(params, @allowed_fields)
  end

  def validated_changeset(user, params) do
    new_changeset(user, params)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_confirmation(:password, message: "must match password")
    |> hash_password()
  end

  defp hash_password(%{changes: %{password: password}, valid?: true} = changeset) do
    put_change changeset, :hashed_password, Comeonin.Bcrypt.hashpwsalt(password)
  end
  defp hash_password(changeset), do: changeset
end
