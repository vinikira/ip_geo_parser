defmodule IpGeoParser.GetGeoDataByIp do
  @moduledoc """
  Fetch a `IpGeoParser.IpInfo` by IP.
  """

  alias IpGeoParser.IpInfo

  @spec call(repo :: module(), ip :: String.t()) :: IpInfo.t() | nil
  def call(repo, ip) do
    repo.get_by(IpInfo, ip: ip)
  end
end
