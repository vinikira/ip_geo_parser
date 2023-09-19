defmodule IpGeoParser.Support.Repo.Migrations.AddIpGeoData do
  use Ecto.Migration

  def up do
    IpGeoParser.Migration.up()
  end

  def down do
    IpGeoParser.Migration.down()
  end
end
