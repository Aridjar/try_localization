use Mix.Config

config :localization,
  job_offers_file: "test/support/csv/technical-test-jobs.csv",
  professions_file: "test/support/csv/technical-test-professions.csv"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :localization, LocalizationWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :localization, Localization.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB_TEST"),
  hostname: System.get_env("POSTGRES_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox
