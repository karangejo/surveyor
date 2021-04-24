# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :surveyor,
  ecto_repos: [Surveyor.Repo]

# Configures the endpoint
config :surveyor, SurveyorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t2cHTBBvWwIaQgax41RJxkceDF9kg1hR/atV9gL1M1W3I82WuJIfPZVKa1aQFnjJ",
  render_errors: [view: SurveyorWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Surveyor.PubSub,
  live_view: [signing_salt: "mpDTKPH5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
