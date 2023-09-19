defmodule IpGeoParser.GetGeoDataByIpTest do
  use IpGeoParser.DataCase, async: true

  alias IpGeoParser.GetGeoDataByIp
  alias IpGeoParser.IpInfo

  describe "call/2" do
    test "should return the IpInfo when found it." do
      ip_info =
        %{
          "ip" => "192.168.0.1",
          "country_code" => "BR",
          "country" => "Brazil",
          "city" => "Santo André",
          "latitude" => -23.674223,
          "longitude" => -46.543598,
          "mystery_value" => 1_231_312
        }
        |> IpInfo.changeset()
        |> Repo.insert!()

      assert GetGeoDataByIp.call(Repo, "192.168.0.1") == ip_info
    end

    test "should return nil when not found it" do
      refute GetGeoDataByIp.call(Repo, "192.168.0.2")
    end
  end
end
