defmodule IpGeoParser.IpInfo do
  @moduledoc """
  IpInfo model
  """
  use Ecto.Schema

  import Ecto.Changeset

  @typedoc """
  The following is the description of the fields:

  - id: big integer identifier.
    Example: 1

  - ip: the IPV4 number.
    Example: 202.94.125.244

  - country_code: the ISO 3166 country code.
    Example: US

  - country_code: the ISO 3166 country name.
    Example: United States

  - country_code: the ISO 3166 country name.
    Example: United States

  - city: the city name.
    Example: Salt Lake City

  - latitude: the approximate latitude of the IP.
    Example: -23.5471

  - longitude: the approximate longitude of the IP.
    Example: -46.6372

  - mystery_value: a large integer value, which is a mistery even for me.
    Example: 7823011346

  - inserted_at: The date of insertion.
    Example: ~U[2023-09-18 21:47:11.036359Z]

  - updated_at: the date of the last modification.
    Example: ~U[2023-09-18 21:47:11.036359Z]
  """
  @type t :: %__MODULE__{
          ip: String.t() | nil,
          country_code: String.t() | nil,
          country: String.t() | nil,
          city: String.t() | nil,
          latitude: float() | nil,
          longitude: float() | nil,
          mystery_value: integer() | nil
        }

  @required ~w(ip country_code country city latitude longitude mystery_value)a
  @optional ~w(inserted_at updated_at)a

  @country_map :ip_geo_parser
               |> Application.app_dir("priv/countries.json")
               |> File.read!()
               |> Jason.decode!()

  schema "ip_geo_data" do
    field :ip, :string
    field :country_code, :string
    field :country, :string
    field :city, :string
    field :latitude, :float
    field :longitude, :float
    field :mystery_value, :integer

    timestamps(type: :utc_datetime)
  end

  @spec changeset(map(), boolean()) :: Ecto.Changeset.t()
  def changeset(params, validate_country \\ false) do
    %__MODULE__{}
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_ip()
    |> validate_country(validate_country)
  end

  defp validate_ip(changeset) do
    ip =
      changeset
      |> get_change(:ip)
      |> to_charlist()

    case :inet.parse_ipv4_address(ip) do
      {:ok, _} ->
        changeset

      {:error, :einval} ->
        add_error(changeset, :ip, "invalid format")
    end
  end

  defp validate_country(changeset, false = _validate_country), do: changeset

  defp validate_country(changeset, _validate_country) do
    country_code = get_change(changeset, :country_code)
    country = get_change(changeset, :country)

    case @country_map[country_code] do
      nil ->
        add_error(changeset, :country_code, "doesn't exist.")

      name when name == country ->
        changeset

      _default ->
        add_error(changeset, :country, "the country name doesn't match the code.")
    end
  end
end
