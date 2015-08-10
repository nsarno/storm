defmodule Storm.Mission do
  use Storm.Web, :model

  schema "missions" do
    field :name, :string
    belongs_to :project, Storm.Project

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

  def changeset(model, %Storm.Project{id: p_id}, params) do
    changeset(model, params)
    |> put_change(:project_id, p_id)
  end
end
