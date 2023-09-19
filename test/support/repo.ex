defmodule IpGeoParser.Support.Repo do
  use Ecto.Repo,
    otp_app: :ip_geo_parser,
    adapter: Ecto.Adapters.Postgres
end

defmodule IpGeoParser.Support.UnboxedRepo do
  use Ecto.Repo,
    otp_app: :ip_geo_parser,
    adapter: Ecto.Adapters.Postgres
end
