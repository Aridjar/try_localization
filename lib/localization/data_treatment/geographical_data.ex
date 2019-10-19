defmodule Localization.GeographicalData do
  defmacro __using__([]) do
    quote do
      @continents %{
        africa: 0,
        antartica: 0,
        asia: 0,
        australia: 0,
        europe: 0,
        north_america: 0,
        south_america: 0,
        total: 0,
        undefined: 0
      }

      @continent_data %{
        africa: 0,
        antartica: 0,
        asia: 0,
        australia: 0,
        europe: 0,
        north_america: 0,
        south_america: 0
      }
    end
  end
end
