# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :repoex,
  ecto_repos: [Repoex.Repo]

config :repoex, Repoex.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :repoex, Repoex, get_repos_adapter: Repoex.GetRepos

# Configures the endpoint
config :repoex, RepoexWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RepoexWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Repoex.PubSub,
  live_view: [signing_salt: "p4Q9aweL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
