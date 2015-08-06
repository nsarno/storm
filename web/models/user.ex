defmodule Winter.User do
  use Winter.Web, :model

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
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> digest_password(params)
  end

  defp digest_password changeset, params do
    import Plug.Crypto.KeyGenerator, only: [generate: 2]
    if changeset.valid? do
      password = changeset.params["password"]
      digest = to_hex generate(password, Winter.Endpoint.config :secret_key_base)
      changeset = Ecto.Changeset.put_change changeset, :password_digest, digest
    end
    changeset
  end

  defp to_hex(value), do: Base.encode16(value, case: :lower)
end
