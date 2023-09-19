defmodule IpGeoParser.MigrationTest do
  use ExUnit.Case, async: false

  alias IpGeoParser.Support.UnboxedRepo

  @version 20_080_906_120_000
  @prefix "test_prefix"

  defmodule MyApp.IpGeoMigration do
    use Ecto.Migration

    @prefix "test_prefix"

    # credo:disable-for-next-line
    def up do
      IpGeoParser.Migration.up(@prefix)
    end

    # credo:disable-for-next-line
    def down do
      IpGeoParser.Migration.down(@prefix)
    end
  end

  describe "migration" do
    test "should migrate and rollback the table properly" do
      {:ok, _} = UnboxedRepo.query("CREATE SCHEMA #{@prefix};")

      assert :ok == Ecto.Migrator.up(UnboxedRepo, @version, MyApp.IpGeoMigration)

      assert table_exists?("ip_geo_data")

      assert :ok == Ecto.Migrator.down(UnboxedRepo, @version, MyApp.IpGeoMigration)
    after
      clear_migrated()
    end
  end

  defp table_exists?(table) do
    query = """
    SELECT EXISTS (
      SELECT 1
      FROM pg_tables
      WHERE tablename = '#{table}'
      AND schemaname = '#{@prefix}'
    )
    """

    {:ok, %{rows: [[bool]]}} = UnboxedRepo.query(query)

    bool
  end

  defp clear_migrated do
    UnboxedRepo.query("DELETE FROM schema_migrations WHERE version >= #{@version}")
    UnboxedRepo.query("DROP SCHEMA IF EXISTS #{@prefix} CASCADE")
  end
end
