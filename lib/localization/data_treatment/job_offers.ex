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

  def get_continent_from_job_offer(job_offer) do
    with {:ok, coordinates} <- get_job_coordinates(job_offer),
         nil <- Enum.find(@continent_data, fn {_, x} -> Topo.contains?(x, coordinates) end) do
      :undefined
    else
      {:error, _} -> :undefined
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

  def get_offers_in_radius(_, _, _, stash \\ [])
  def get_offers_in_radius([], _, _, stash), do: stash

  def get_offers_in_radius([head | tail], coordinates, radius, stash) do
    new_stash =
      with {:ok, offer_coordinates} <- get_job_coordinates(head),
           {:ok, applicant_coordinates} <- get_coordinates(coordinates) do
        Distance.GreatCircle.distance(offer_coordinates, applicant_coordinates)
        |> create_new_stash_if_in_radius(head, radius, stash)
      else
        _ -> stash
      end

    get_offers_in_radius(tail, coordinates, radius, new_stash)
  end

  def create_new_stash_if_in_radius(distance, job_offer, radius, stash) do
    if distance < radius * 1000 do
      new_job_offer =
        %{"distance" => distance}
        |> Enum.into(job_offer)

      stash ++ [new_job_offer]
    else
      stash
    end
  end

  def get_job_coordinates(%{"office_latitude" => latitude, "office_longitude" => longitude})
      when bit_size(latitude) == 0 or bit_size(longitude) == 0 or
             is_nil(latitude) or is_nil(longitude) do
    {:error, :undefined}
  end

  def get_job_coordinates(%{"office_latitude" => latitude, "office_longitude" => longitude}) do
    get_coordinates({latitude, longitude})
  end

  def get_coordinates({latitude, longitude}) do
    new_latitude = String.to_float(latitude)
    new_longitude = String.to_float(longitude)
    {:ok, {new_latitude, new_longitude}}
  end
end
