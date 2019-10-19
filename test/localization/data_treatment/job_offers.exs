defmodule Localization.ImportCsvTest do
  use Localization.DataCase
  use Localization.GeographicalData

  @simplify_professions %{"1" => "category", "2" => "name", "3" => "name"}

  @stash %{
    "total" => @continents,
    "category" => @continents,
    "name" => @continents,
    "undefined" => @continents
  }

  @job_offers [
    %{"profession_id" => "1"},
    %{"profession_id" => "2"},
    %{"profession_id" => "3"},
    %{"profession_id" => "1"}
  ]

  @result []

  test "create base stash" do
    assert ImportCsv.create_base_stash(@simplify_professions) == @stash
  end

  test "sort data per professions" do
    assert ImportCsv.sort_data_per_professions(@job_offers, @simplify_professions, @stash) == %{
             "total" => 4,
             "category" => 2,
             "name" => 2,
             "undefined" => 0
           }
  end
end
