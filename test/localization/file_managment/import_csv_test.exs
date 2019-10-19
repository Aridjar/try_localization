defmodule Localization.ImportCsvTest do
  use Localization.DataCase
  alias Localization.ImportCsv

  @simplify_professions %{"1" => "category", "2" => "name", "3" => "name"}
  @stash %{"total" => 0, "category" => 0, "name" => 0, "undefined" => 0}
  @job_offers [
    %{"profession_id" => "1"},
    %{"profession_id" => "2"},
    %{"profession_id" => "3"},
    %{"profession_id" => "1"}
  ]

  test "import_data_from_path" do
    assert ImportCsv.import_data_from_path("test/support/csv/test.csv") == [
             %{"field1" => "1", "field2" => "2"},
             %{"field1" => "3", "field2" => "4"}
           ]
  end

  test "get_data" do
    assert {
             [
               %{
                 "profession_id" => _,
                 "contract_type" => _,
                 "name" => _,
                 "office_latitude" => _,
                 "office_longitude" => _
               }
               | _
             ],
             [%{"id" => _, "name" => _, "category_name" => _} | _]
           } = ImportCsv.get_data()
  end

  test "simplify professions data" do
    assert ImportCsv.simplify_professions_data([
             %{"id" => "1", "category_name" => "category"},
             %{"id" => "2", "category_name" => "name"},
             %{"id" => "3", "category_name" => "name"}
           ]) == @simplify_professions
  end

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
