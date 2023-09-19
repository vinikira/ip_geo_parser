defmodule IpGeoParser.ImportFromFile do
  @moduledoc """
  Reads a CSV file, parse the lines to `IpGeoParser.IpInfo` structures,
  and then simultaneously batches inserts into the `ip_geo_data` table.

  The batch and concurrency can be customized. See the `t:option/0`.
  """
  alias Ecto.Changeset
  alias IpGeoParser.IpInfo
  alias NimbleCSV.RFC4180

  @typedoc """
  The following is the description of the options:

  - **batch_size**: the size of the batch of rows to be processed.
    Default: 50

  - **max_concurrency**: the number of workers that will process the batches.
    Default: 10

   - **validate_country**: whether should validate country code and name or not.
    Default: false
  """
  @type option ::
          {:batch_size, pos_integer()}
          | {:max_concurrency, pos_integer()}
          | {:validate_country, boolean()}

  @type result :: {integer(), [Changeset.t()]}

  @default_batch_size 50
  @default_max_concurrency 10
  @default_validate_country false

  @spec call(file_path :: String.t(), repo :: module, [option()]) :: result()
  def call(file_path, repo, opts \\ []) do
    {batch_size, opts!} = Keyword.pop(opts, :batch_size, @default_batch_size)
    {max_concurrency, opts!} = Keyword.pop(opts!, :max_concurrency, @default_max_concurrency)
    {validate_country, _opts!} = Keyword.pop(opts!, :validate_country, @default_validate_country)

    file_path
    |> File.stream!()
    |> RFC4180.parse_stream()
    |> Stream.chunk_every(batch_size)
    |> Task.async_stream(&process_batch(&1, repo, validate_country),
      max_concurrency: max_concurrency
    )
    |> process_result()
  end

  defp process_batch(batch, repo, validate_country) do
    parsed_batches = parse_batch(batch, validate_country)

    {inserted, _} =
      (parsed_batches[:valid] || [])
      |> Enum.map(fn changeset ->
        changeset
        |> Changeset.apply_action!(:import_from_file)
        |> Map.from_struct()
        |> Map.drop([:__meta__, :id])
      end)
      |> Enum.uniq_by(fn %{ip: ip} -> ip end)
      |> then(
        &repo.insert_all(IpInfo, &1,
          conflict_target: [:ip],
          on_conflict: :replace_all
        )
      )

    {inserted, parsed_batches[:invalid]}
  end

  defp parse_batch(batch, validate_country) do
    batch
    |> Enum.map(fn
      [ip, country_code, country, city, latitude, longitude, mystery_value] ->
        now = NaiveDateTime.utc_now()

        IpInfo.changeset(
          %{
            ip: ip,
            country_code: country_code,
            country: country,
            city: city,
            latitude: latitude,
            longitude: longitude,
            mystery_value: mystery_value,
            inserted_at: now,
            updated_at: now
          },
          validate_country
        )

      _invalid_csv_line ->
        IpInfo.changeset(%{})
    end)
    |> Enum.group_by(fn
      %Ecto.Changeset{valid?: true} -> :valid
      _invalid_changeset -> :invalid
    end)
  end

  defp process_result(import_result) do
    Enum.reduce(import_result, {0, []}, fn
      {:ok, {inserted, nil}}, {inserted_acc, errors_acc} ->
        {inserted + inserted_acc, errors_acc}

      {:ok, {inserted, errors}}, {inserted_acc, errors_acc} ->
        {inserted + inserted_acc, Enum.concat(errors, errors_acc)}
    end)
  end
end
