defmodule Localization.ImportCsvTest do
  use Localization.DataCase
  alias Localization.ImportCsv

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
end
