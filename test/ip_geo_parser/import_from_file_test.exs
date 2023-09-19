defmodule IpGeoParser.ImportFromFileTest do
  use IpGeoParser.DataCase, async: true

  alias IpGeoParser.ImportFromFile

  @file_path Path.expand("test/fixtures/ip_geo_data.csv")

  @tmp_file_name "data.csv"

  describe "call" do
    test "should parse the CSV file and return properly" do
      assert {inserted, errors} = ImportFromFile.call(@file_path, Repo)

      assert inserted == 2214
      assert length(errors) == 217
    end

    test "should report validation errors" do
      csv = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,Nepal,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      ,PY,Falkland,Islands,75.41685191518815,-144.6943217219469,0
      """

      with_tmp_csv(csv, fn tmp_file_path ->
        assert {inserted, [error]} = ImportFromFile.call(tmp_file_path, Repo)

        assert inserted == 1

        assert errors_on(error) == %{ip: ["invalid format", "can't be blank"]}
      end)
    end

    test "should validate country if flag is true" do
      csv = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,US,Brazil,Sao Paulo,-84.87503094689836,7.206435933364332,7823011346
      200.106.141.16,DS,United States,New York,-84.87503094689836,7.206435933364332,7823011346
      """

      with_tmp_csv(csv, fn tmp_file_path ->
        assert {inserted, [error1, error2]} =
                 ImportFromFile.call(tmp_file_path, Repo, validate_country: true)

        assert inserted == 0

        assert errors_on(error1) == %{country: ["the country name doesn't match the code."]}
        assert errors_on(error2) == %{country_code: ["doesn't exist."]}
      end)
    end

    test "should generate invalid changesets for lines with less than 7 columns" do
      csv = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,Nepal,DuBuquemouth,-84.87503094689836,7.206435933364332
      ,PY,Falkland,Islands,-144.6943217219469,0
      """

      with_tmp_csv(csv, fn tmp_file_path ->
        assert {inserted, [error1, error2]} = ImportFromFile.call(tmp_file_path, Repo)

        assert inserted == 0

        assert errors_on(error1) == %{
                 ip: ["invalid format", "can't be blank"],
                 city: ["can't be blank"],
                 country: ["can't be blank"],
                 country_code: ["can't be blank"],
                 latitude: ["can't be blank"],
                 longitude: ["can't be blank"],
                 mystery_value: ["can't be blank"]
               }

        assert errors_on(error2) == %{
                 ip: ["invalid format", "can't be blank"],
                 city: ["can't be blank"],
                 country: ["can't be blank"],
                 country_code: ["can't be blank"],
                 latitude: ["can't be blank"],
                 longitude: ["can't be blank"],
                 mystery_value: ["can't be blank"]
               }
      end)
    end
  end

  defp with_tmp_csv(csv, fun) do
    tmp_file_path = Path.expand([System.tmp_dir!(), @tmp_file_name])

    try do
      :ok = File.touch!(tmp_file_path)
      :ok = File.write!(tmp_file_path, csv)
      fun.(tmp_file_path)
    after
      File.rm!(tmp_file_path)
    end
  end
end
