defmodule IpGeoParser do
  @moduledoc """
  Library for parse, store and retrieve IP's geo localization information.

  Currently it only supports import data from a CSV file.
  """
  alias IpGeoParser.GetGeoDataByIp
  alias IpGeoParser.ImportFromFile

  @doc """
  Imports the `IpGeoParser.IpInfo` from a CSV file and save them into the `ip_geo_data` table.

  For more information, check `IpGeoParser.ImportFromFile`.
  """
  defdelegate import_from_file(file_path, repo, opts), to: ImportFromFile, as: :call

  @doc """
  Gets an `IpGeoParser.IpInfo` by IP.

  For more information, check `IpGeoParser.GetGeoDataByIp`.
  """
  defdelegate get_by_ip(repo, ip), to: GetGeoDataByIp, as: :call
end
