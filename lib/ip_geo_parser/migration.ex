defmodule IpGeoParser.Migration do
  @moduledoc """
  Migration to generate the `ip_geo_data` table.
  This module should be used inside a real Ecto migration.

  ### Example:

  ```elixir
   defmodule MyApp.Repo.Migrations.AddIpGeoData do
     use Ecto.Migration

     def up do
       IpGeoParser.Migration.up()
     end

     def down do
       IpGeoParser.Migration.down()
     end
   end
  ```
  """
  use Ecto.Migration

  @default_prefix "public"

  def up(prefix \\ @default_prefix) do
    create_if_not_exists table(:ip_geo_data, prefix: prefix) do
      add :ip, :string, size: 15, null: false
      add :country_code, :string, null: false
      add :country, :string, null: false
      add :city, :string, null: false
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :mystery_value, :bigint, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:ip_geo_data, [:ip], prefix: prefix)
  end

  def down(prefix \\ @default_prefix) do
    drop unique_index(:ip_geo_data, [:ip], prefix: prefix)
    drop table(:ip_geo_data, prefix: prefix)
  end
end
