defmodule Localization.GeographicalData do
  @moduledoc """
    GeographicalData is a simple module use to pass geographical data to any other module which may need it.
  """

  defmacro __using__([]) do
    quote do
      @continents %{
        africa: 0,
        america: 0,
        antartica: 0,
        asia: 0,
        europe: 0,
        oceania: 0,
        total: 0,
        undefined: 0
      }

      # note : the coordinates are generaly : North, west, south, east, north
      # if you modify any, please, validate this format
      @continent_data %{
        africa: %Geo.Polygon{
          coordinates: [
            [{37.53, 8.93}, {14.87, -24.73}, {-34.82, 20.00}, {-19.66, 63.50}, {37.53, 8.93}]
          ]
        },
        america: %Geo.Polygon{
          coordinates: [
            [{83.66, -30.66}, {52.8, 173.2}, {-59.5, -27.4}, {81.45, -11.31}, {83.66, -30.66}]
          ]
        },
        antartica: %Geo.Polygon{
          coordinates: [
            [{-63.38, -57}, {-90, 180}, {-90, 0}, {-90, -180}, {-63.38, -57}]
          ]
        },
        asia: %Geo.Polygon{
          coordinates: [
            [
              {81.16, 95.83},
              {81.83, 59.233},
              {39.47, 26.06},
              {1.26, 103.5},
              {66.07, -169.65},
              {81.16, 95.83}
            ]
          ]
        },
        europe: %Geo.Polygon{
          coordinates: [
            [{71.18, 25.68}, {65.5, -24.53}, {34.82, 24.8}, {65.25, 67.73}, {71.18, 25.68}]
          ]
        },
        oceania: %Geo.Polygon{
          coordinates: [
            [{28.41, -178.3}, {-53.01, -72.56}, {-52.61, 198.13}, {24.4, -124.8}, {28.41, -178.3}]
          ]
        }
      }
    end
  end
end
