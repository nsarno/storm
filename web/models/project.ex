defmodule Storm.Project do
  use Storm.Web, :model

  schema "projects" do
    field :name, :string
    belongs_to :user, Storm.User
    has_many :missions, Storm.Mission

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(model, %Storm.User{id: user_id}, params) do
    changeset(model, params)
    |> put_change(:user_id, user_id)
  end
end
