defmodule Localization.ImportCsv do
  def do_script() do
    {job_offer, professions} = get_data()
    simple_professions = simplify_professions_data(professions)
  end

  def get_data() do
    job_offers = import_data_from_path("assets/csv/technical-test-jobs.csv")
    professions = import_data_from_path("assets/csv/technical-test-professions.csv")

    {job_offers, professions}
  end

  def import_data_from_path(filepath) do
    filepath
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.to_list()
    |> Enum.map(fn {_, value} -> value end)
  end

  def simplify_professions_data(professions) do
    professions
    |> Map.new(fn %{"id" => id, "category_name" => category_name} -> {id, category_name} end)
  end
end
