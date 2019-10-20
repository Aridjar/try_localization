defmodule Localization.ImportCsv do
  @moduledoc """
    ImportCsv is a module to import a CSV file, take data out and sort them.

    The function `do_script/0` as for purpose to be called from iex to test the script

    The simplified_professions professions element is a map where the `id` is the key and the category's name the value, such as :

    `%{"id" => "category_name", ...}

    This reduce the complexity of the first part.

    The function `import_data_from_path` allows you to create a list of map from a CSV.
    **Important**: the CSV must have a header
  """

  alias Localization.JobOffers

  def do_script() do
    {job_offers, professions} = get_data()
    simplified_professions = simplify_professions_data(professions)
    stash = JobOffers.create_base_stash(simplified_professions)

    JobOffers.sort_data_per_professions(job_offers, simplified_professions, stash)
  end

  def get_data() do
    job_offers =
      Application.get_env(:localization, :job_offers_file)
      |> import_data_from_path()

    professions =
      Application.get_env(:localization, :professions_file)
      |> import_data_from_path()

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
