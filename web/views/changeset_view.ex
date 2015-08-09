defmodule Winter.ChangesetView do
  use Winter.Web, :view

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: changeset}
  end

  def render("error.json", %{reason: reason}) do
    %{errors: reason}
  end
end
