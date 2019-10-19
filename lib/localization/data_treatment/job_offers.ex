defmodule Localization.JobOffers do
  @moduledoc """
    Job offer is a module where logic about job offers will be executed
    It mains logic consist of a recusrive functio `sort_data_per_professions/3`
    This function takes
      * a job_offers list
      * a `simplified_professions` map
      * a stash map
    and should return a stash map

    To know more about the simplified_profession map, please refere to the `Localization.ImportCsv` documentation

    You can use `create_base_stash` to create a stash map
    `create_base_stash` only takes one argument, which is a `simplified_professions` map.

    ## Stashs

    Here, a stash is a two dimentionnal map.
    The first dimensions is variable in size, has it depends of the number of professions in a `simplified_professions` map.
    The second dimensions is a list of continent.
    Both dimensions have a `:total` and an `:undefined` field.
  """

  use Localization.GeographicalData

  def create_base_stash(simplified_professions) do
    simplified_professions
    |> Map.values()
    |> Enum.uniq()
    |> Map.new(fn name -> {name, @continents} end)
    |> Enum.into(%{total: @continents, undefined: @continents})
  end

  def sort_data_per_professions([], _, stash), do: stash

  def sort_data_per_professions([head | tail], simplified_professions, stash) do
    category = get_profession_from_job_offer(head, simplified_professions)
    continent = get_continent_from_job_offer(head)

    new_stash = generate_new_stash(stash, category, continent)

    sort_data_per_professions(tail, simplified_professions, new_stash)
  end

  ################
  ### Get keys ###
  ################

  def get_profession_from_job_offer(%{"profession_id" => profession_id}, simplified_professions) do
    with {:ok, val} <- Map.fetch(simplified_professions, profession_id) do
      val
    else
      _ -> :undefined
    end
  end

  def get_continent_from_job_offer(%{
        "office_latitude" => office_latitude,
        "office_longitude" => office_longitude
      })
      when bit_size(office_latitude) == 0 or bit_size(office_longitude) == 0 or
             is_nil(office_latitude) or is_nil(office_longitude) do
    :undefined
  end

  def get_continent_from_job_offer(%{
        "office_latitude" => office_latitude,
        "office_longitude" => office_longitude
      }) do
    latitude = String.to_float(office_latitude)
    longitude = String.to_float(office_longitude)

    with nil <-
           Enum.find(@continent_data, fn {_, x} -> Topo.contains?(x, {latitude, longitude}) end) do
      :undefined
    else
      result -> elem(result, 0)
    end
  end

  ####################
  ### Update stash ###
  ####################

  def generate_new_stash(stash, category, continent) do
    update_total = update_category(stash, category, continent)
    update_category = update_total(stash, continent)

    stash
    |> Map.merge(update_total)
    |> Map.merge(update_category)
  end

  defp update_category(stash, category, continent) do
    updated_category =
      stash
      |> Map.get(category)
      |> Map.update!(:total, &(&1 + 1))
      |> Map.update!(continent, &(&1 + 1))

    %{category => updated_category}
  end

  defp update_total(stash, continent) do
    updated_total =
      stash
      |> Map.get(:total)
      |> Map.update!(:total, &(&1 + 1))
      |> Map.update!(continent, &(&1 + 1))

    %{total: updated_total}
  end

  def get_offers_in_radius(job_offers, coordinates, radius) do
    [Enum.at(job_offers, 0), Enum.at(job_offers, 1)]
  end
end
