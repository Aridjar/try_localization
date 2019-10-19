defmodule Localization.ImportCsv do
  def do_script() do
    {job_offers, professions} = get_data()
    simplify_professions = simplify_professions_data(professions)
    stash = create_base_stash(simplify_professions)

    sort_data_per_professions(job_offers, simplify_professions, stash)
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

  def create_base_stash(simplify_professions) do
    simplify_professions
    |> Map.values()
    |> Enum.uniq()
    |> Map.new(fn name -> {name, 0} end)
    |> Enum.into(%{"total" => 0, "undefined" => 0})
  end

  def sort_data_per_professions([], _, stash), do: stash

  def sort_data_per_professions([%{"profession_id" => id} | tail], simplify_professions, stash) do
    key =
      with {:ok, val} <- Map.fetch(simplify_professions, id) do
        val
      else
        _ -> "undefined"
      end

    new_stash =
      stash
      |> Map.update!(key, &(&1 + 1))
      |> Map.update!("total", &(&1 + 1))

    sort_data_per_professions(tail, simplify_professions, new_stash)
  end
end
