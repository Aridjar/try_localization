defmodule Localization.JobOffers do
  use Localization.GeographicalData

  def create_base_stash(simplified_professions) do
    simplified_professions
    |> Map.values()
    |> Enum.uniq()
    |> Map.new(fn name -> {name, @continents} end)
    |> Enum.into(%{"total" => @continents, "undefined" => @continents})
  end

  def sort_data_per_professions([], _, stash), do: stash

  def sort_data_per_professions([head | tail], simplified_professions, stash) do
    key = head |> get_profession_from_job_offer(simplified_professions)
    continent = head |> get_continent_from_job_offer()

    new_stash = stash |> generate_new_stash(key, continent)

    sort_data_per_professions(tail, simplified_professions, new_stash)
  end

  def get_profession_from_job_offer(%{"profession_id" => profession_id}, simplified_professions) do
    with {:ok, val} <- Map.fetch(simplified_professions, profession_id) do
      val
    else
      _ -> "undefined"
    end
  end

  def get_continent_from_job_offer(%{
        "office_latitude" => latitude,
        "office_longitude" => longitude
      }) do
    {latitude, longitude}
  end

  def generate_new_stash(stash, key, continent) do
    update_total = stash |> update_category(key, continent)
    update_category = stash |> update_total(continent)

    stash
    |> Map.merge(update_total)
    |> Map.merge(update_category)
  end

  defp update_category(stash, key, continent) do
    stash
    |> Map.get(key)
    |> Map.update!("total", &(&1 + 1))
    |> Map.update!(continent, &(&1 + 1))
  end

  defp update_total(stash, continent) do
    stash
    |> Map.get("total")
    |> Map.update!("total", &(&1 + 1))
    |> Map.update!(continent, &(&1 + 1))
  end
end
