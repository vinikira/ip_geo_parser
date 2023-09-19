defmodule IpGeoParser.IpInfoTest do
  use ExUnit.Case, async: true

  alias Ecto.Changeset
  alias IpGeoParser.IpInfo

  describe "changeset/2" do
    setup do
      [
        fixture: %{
          "ip" => "192.168.0.1",
          "country_code" => "BR",
          "country" => "Brazil",
          "city" => "Santo André",
          "latitude" => -23.674223,
          "longitude" => -46.543598,
          "mystery_value" => 1_231_312
        }
      ]
    end

    test "should validate ip address", ctx do
      params = Map.put(ctx.fixture, "ip", "2333.32.23.32")

      assert %Changeset{valid?: false, errors: errors} = IpInfo.changeset(params)

      assert errors == [ip: {"invalid format", []}]
    end

    test "should validate country code", ctx do
      params = Map.put(ctx.fixture, "country_code", "INVALID")

      assert %Changeset{valid?: false, errors: errors} = IpInfo.changeset(params, true)

      assert errors == [country_code: {"doesn't exist.", []}]
    end

    test "should validate country name", ctx do
      params = Map.put(ctx.fixture, "country", "INVALID code ")

      assert %Changeset{valid?: false, errors: errors} = IpInfo.changeset(params, true)

      assert errors == [country: {"the country name doesn't match the code.", []}]
    end

    test "should parse properly", ctx do
      assert %Changeset{valid?: true} = IpInfo.changeset(ctx.fixture)
    end
  end
end
