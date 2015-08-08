defmodule Winter.ErrorViewTest do
  use Winter.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(Winter.ErrorView, "404.json", []) ==
           "{\"error\":\"Page not found\"}"
  end

  test "render 500.html" do
    assert render_to_string(Winter.ErrorView, "500.json", []) ==
           "{\"error\":\"Server internal error\"}"
  end

  test "render any other" do
    assert render_to_string(Winter.ErrorView, "505.json", []) ==
           "{\"error\":\"Server internal error\"}"
  end
end
