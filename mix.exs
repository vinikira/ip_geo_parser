defmodule IpGeoParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :ip_geo_parser,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      test_coverage: [summary: [threshold: 85]]
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev]},
      {:dialyxir, "~> 1.4", only: [:dev]},
      {:ecto, "~> 3.10"},
      {:ecto_sql, "~> 3.10"},
      {:ex_doc, "~> 0.25", only: :dev},
      {:jason, "~> 1.4"},
      {:postgrex, "~> 0.17.3"},
      {:nimble_csv, "~> 1.2"}
    ]
  end

  defp aliases do
    [
      "test.setup": [
        "ecto.drop --quiet -r IpGeoParser.Support.Repo",
        "ecto.create --quiet -r IpGeoParser.Support.Repo",
        "ecto.migrate --quiet -r IpGeoParser.Support.Repo"
      ]
    ]
  end
end
