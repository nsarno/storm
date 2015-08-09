defmodule Winter.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Winter.Web, :controller
      use Winter.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Model
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      # Alias the data repository and import query/model functions
      alias Winter.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      # Import URL helpers from the router
      import Winter.Router.Helpers

      import Winter.AuthToken, only: [authenticate!: 2]
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [view_module: 1]

      # Import URL helpers from the router
      import Winter.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      # Alias the data repository and import query/model functions
      alias Winter.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
