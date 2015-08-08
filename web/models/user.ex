defmodule Winter.User do
  use Winter.Web, :model
  import Ecto.Query
  alias Winter.User
  alias Winter.Repo

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(name email password)
  @optional_fields ~w()

  @doc """
    Find a user by email or raise an exception

    Returns a `Winter.User` struct corresponding to the `email` parameter
    or raises Ecto.NoResultsError.
  """
  def find_by_email! email do
    query = from u in User, where: ^email == u.email, select: u
    Repo.one! query
  end

  @doc """
    Assert email/password combination

    Returns a `Winter.User` struct corresponding to the `email`/`password`
    parameters or raises Ecto.NoResultsError.
  """
  def authenticate! email, pwd do
    user = find_by_email! email
    if user.password_digest != digest_password(pwd), do: raise NoResultsError
    user
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_password
  end

  defp validate_password changeset do
    if changeset.valid? do
      pwd = changeset.params["password"]
      Ecto.Changeset.put_change changeset, :password_digest, digest_password(pwd)
    else
      changeset
    end
  end

  def digest_password pwd do
    import Plug.Crypto.KeyGenerator, only: [generate: 2]
    to_hex generate(pwd, Winter.Endpoint.config :secret_key_base)
  end

  defp to_hex(value), do: Base.encode16(value, case: :lower)
end
