defmodule Localization.ImportCsv do
  import Ecto.Query
  alias Localization.Repo

  def import_data_from_path(filepath) do
    filepath
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.to_list()
    |> Enum.map(fn {_, value} -> value end)
  end

  def get_data() do
    job_offers = import_data_from_path("assets/csv/technical-test-jobs.csv")
    professions = import_data_from_path("assets/csv/technical-test-professions.csv")

    {job_offers, professions}
  end
end
