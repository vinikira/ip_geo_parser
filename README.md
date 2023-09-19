# IpGeoParser

Library to parse IP geolocalization data and insert them into the
database.

WARNING: Do not use this, it is not production ready and was made as
part of an interview assessment.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ip_geo_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ip_geo_parser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ip_geo_parser>.

## Test

In order to test make sure you have an instance of Postgres up and
running (you can use the docker-compose.yml shipped with the project),
then in your terminal run the following commands:

``` shell
MIX_ENV=test mix test.setup # must only be run once
MIX_ENV=test mix test
```
