defmodule Localization.ImportCsv do
  alias Localization.JobOffers

  def do_script() do
    {job_offers, professions} = get_data()
    simplified_professions = simplify_professions_data(professions)
    stash = JobOffers.create_base_stash(simplified_professions)

    JobOffers.sort_data_per_professions(job_offers, simplified_professions, stash)
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
