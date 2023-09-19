Application.ensure_all_started(:postgrex)

IpGeoParser.Support.Repo.start_link()
IpGeoParser.Support.UnboxedRepo.start_link()

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(IpGeoParser.Support.Repo, :manual)
