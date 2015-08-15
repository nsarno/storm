defmodule Storm.User do
  use Storm.Web, :model
  alias Storm.User
  alias Storm.Repo

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string
    field :password, :string, virtual: true
    has_many :projects, Storm.Project
    has_many :projects_missions, through: [:projects, :missions]

    timestamps
  end

  @required_fields ~w(name email password)
  @optional_fields ~w()

  @doc """
    Assert password validity

    Returns true if password is valid or else false.
  """
  def verify_password %User{password_digest: digest}, pwd do
    digest == digest_password(pwd)
  end

  @doc """
    Creates a changeset based on the `model` and `params`.

    If no params are provided, an invalid changeset is returned
    with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_unique(:email, on: Repo)
    |> validate_length(:password, min: 6)
    |> validate_password
  end

  defp validate_password changeset do
    case changeset.params["password"] do
      pwd when is_binary(pwd) ->
        Ecto.Changeset.put_change changeset, :password_digest, digest_password(pwd)
      _ ->
        Ecto.Changeset.add_error changeset, :password, "invalid"
    end
  end

  @doc """
    Hash password to store it securely in database.

    Returns an hexadecimal encoded string.
  """
  def digest_password pwd do
    import Plug.Crypto.KeyGenerator, only: [generate: 2]
    to_hex generate(pwd, Storm.Endpoint.config :secret_key_base)
  end

  defp to_hex(value), do: Base.encode16(value, case: :lower)
end
