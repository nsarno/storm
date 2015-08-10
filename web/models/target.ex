defmodule Winter.Target do
  use Winter.Web, :model

  schema "targets" do
    field :method, :string
    field :url, :string
    belongs_to :mission, Winter.Mission

    timestamps
  end

  @required_fields ~w(method url)
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

  def changeset(model, %Winter.Mission{id: m_id}, params) do
    changeset(model, params)
    |> put_change(:mission_id, m_id)
  end
end
