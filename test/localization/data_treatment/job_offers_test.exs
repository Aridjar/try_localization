defmodule Localization.JobOffersTest do
  use Localization.DataCase
  use Localization.GeographicalData

  alias Localization.JobOffers

  @simplified_professions %{"1" => "category", "2" => "name", "3" => "name"}

  @stash %{
    :total => @continents,
    "category" => @continents,
    "name" => @continents,
    :undefined => @continents
  }

  @job_offer %{
    "profession_id" => "1",
    "office_latitude" => "51.35",
    "office_longitude" => "51.35"
  }

  @bad_job_offer %{
    "profession_id" => nil,
    "office_latitude" => "",
    "office_longitude" => ""
  }

  @job_offers [
    @job_offer,
    %{"profession_id" => "2", "office_latitude" => "51.35", "office_longitude" => "51.35"},
    %{"profession_id" => "3", "office_latitude" => "51.35", "office_longitude" => "51.35"},
    %{"profession_id" => "1", "office_latitude" => "51.35", "office_longitude" => "51.35"},
    @bad_job_offer
  ]

  @result %{
    "category" => %{
      africa: 0,
      america: 2,
      antartica: 0,
      asia: 0,
      europe: 0,
      oceania: 0,
      total: 2,
      undefined: 0
    },
    "name" => %{
      africa: 0,
      america: 2,
      antartica: 0,
      asia: 0,
      europe: 0,
      oceania: 0,
      total: 2,
      undefined: 0
    },
    :total => %{
      africa: 0,
      america: 4,
      antartica: 0,
      asia: 0,
      europe: 0,
      oceania: 0,
      total: 5,
      undefined: 1
    },
    :undefined => %{
      africa: 0,
      america: 0,
      antartica: 0,
      asia: 0,
      europe: 0,
      oceania: 0,
      total: 1,
      undefined: 1
    }
  }

  test "create base stash" do
    assert JobOffers.create_base_stash(@simplified_professions) == @stash
  end

  test "sort data per professions" do
    assert JobOffers.sort_data_per_professions(@job_offers, @simplified_professions, @stash) ==
             @result
  end

  test "get profession from job offer" do
    assert JobOffers.get_profession_from_job_offer(@job_offer, @simplified_professions) ==
             "category"

    assert JobOffers.get_profession_from_job_offer(@bad_job_offer, @simplified_professions) ==
             :undefined
  end

  test "get continent from job offer" do
    assert JobOffers.get_continent_from_job_offer(@job_offer) == :america
    assert JobOffers.get_continent_from_job_offer(@bad_job_offer) == :undefined
  end

  test "generate new stash" do
    new_stash = JobOffers.generate_new_stash(@stash, :undefined, :europe)

    total_total = new_stash |> Map.get(:total) |> Map.get(:total)
    total_europe = new_stash |> Map.get(:total) |> Map.get(:europe)
    total_undefined = new_stash |> Map.get(:total) |> Map.get(:undefined)
    total_asia = new_stash |> Map.get(:total) |> Map.get(:asia)
    undefined_europe = new_stash |> Map.get(:total) |> Map.get(:europe)
    undefined_africa = new_stash |> Map.get(:total) |> Map.get(:africa)

    assert total_total == 1
    assert total_europe == 1
    assert total_undefined == 0
    assert total_asia == 0
    assert undefined_europe == 1
    assert undefined_africa == 0
  end
end
