defmodule Storm.MissionController do
  use Storm.Web, :controller

  alias Storm.Mission

  plug :scrub_params, "mission" when action in [:create, :update]
  plug :authenticate!
  plug :find_project when action in [:index, :create]

  def index(conn, _params) do
    missions = Repo.all(Mission)
    render(conn, "index.json", missions: missions)
  end

  def create(conn, %{"mission" => mission_params}) do
    changeset = Mission.changeset(%Mission{}, conn.assigns[:project], mission_params)

    case Repo.insert(changeset) do
      {:ok, mission} ->
        conn
        |> put_status(:created)
        |> render("show.json", mission: mission)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Storm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    mission = Repo.get!(Mission, id)
    render conn, "show.json", mission: mission
  end

  def update(conn, %{"id" => id, "mission" => mission_params}) do
    mission = Repo.get!(Mission, id)
    changeset = Mission.changeset(mission, mission_params)

    case Repo.update(changeset) do
      {:ok, mission} ->
        render(conn, "show.json", mission: mission)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Storm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    mission = Repo.get!(Mission, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    mission = Repo.delete!(mission)

    send_resp(conn, :no_content, "")
  end

  defp find_project conn, _ do
    conn
    |> assign(:project, Repo.get!(assoc(conn.assigns[:user], :projects), conn.params["project_id"]))
  end

end
