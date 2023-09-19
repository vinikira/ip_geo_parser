import Config

config :ip_geo_parser, IpGeoParser.Support.Repo,
  database: "ip_geo_parser_test",
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DATABASE_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  priv: "test/support/"

config :ip_geo_parser, IpGeoParser.Support.UnboxedRepo,
  database: "ip_geo_parser_test",
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DATABASE_HOST", "localhost")

config :logger, level: :warning
