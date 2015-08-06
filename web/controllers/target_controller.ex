defmodule Winter.TargetController do
  use Winter.Web, :controller

  alias Winter.Target

  plug :scrub_params, "target" when action in [:create, :update]

  def index(conn, _params) do
    targets = Repo.all(Target)
    render(conn, "index.json", targets: targets)
  end

  def create(conn, %{"target" => target_params}) do
    changeset = Target.changeset(%Target{}, target_params)

    case Repo.insert(changeset) do
      {:ok, target} ->
        render(conn, "show.json", target: target)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Winter.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    target = Repo.get!(Target, id)
    render conn, "show.json", target: target
  end

  def update(conn, %{"id" => id, "target" => target_params}) do
    target = Repo.get!(Target, id)
    changeset = Target.changeset(target, target_params)

    case Repo.update(changeset) do
      {:ok, target} ->
        render(conn, "show.json", target: target)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Winter.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    target = Repo.get!(Target, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    _target = Repo.delete!(target)

    send_resp(conn, :no_content, "")
  end
end
