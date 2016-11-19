# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :excelmerger,
  ecto_repos: [Excelmerger.Repo]

# Configures the endpoint
config :excelmerger, Excelmerger.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QtiOkOM89vVFDjxImADuVxjO8nFkZondHxCk/OcjJg9AZoJmYJj28YQGDStDxsMg",
  render_errors: [view: Excelmerger.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Excelmerger.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
