defmodule Winter.Mission do
  use Winter.Web, :model

  schema "missions" do
    field :name, :string
    belongs_to :project, Winter.Project

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

  def changeset(model, %Winter.Project{id: project_id}, params) do
    changeset(model, params)
    |> put_change(:project_id, project_id)
  end
end
