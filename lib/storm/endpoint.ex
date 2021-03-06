defmodule Storm.Endpoint do
  use Phoenix.Endpoint, otp_app: :storm

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.

  # No static files - No need for this
  # plug Plug.Static,
  #   at: "/", from: :storm, gzip: false,
  #   only: ~w(css images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # Not using sessions - No need for this
  # plug Plug.Session,
  #   store: :cookie,
  #   key: "_storm_key",
  #   signing_salt: "1KI8UKYa"

  plug CORSPlug, [origin: "http://localhost:4200"]

  plug Storm.Router
end
