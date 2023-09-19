import Config

config :ip_geo_parser, IpGeoParser.Support.Repo,
  database: "ip_geo_parser_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 100,
  priv: "test/support/"

config :ip_geo_parser, IpGeoParser.Support.UnboxedRepo,
  database: "ip_geo_parser_migration_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
