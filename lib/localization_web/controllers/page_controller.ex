defmodule LocalizationWeb.PageController do
  use LocalizationWeb, :controller

  alias Localization.{JobOffers, ImportCsv}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def get_job_offers(conn, %{"latitude" => latitude, "longitude" => longitude, "radius" => radius}) do
    job_offers =
      "assets/csv/technical-test-jobs.csv"
      |> ImportCsv.import_data_from_path()
      |> JobOffers.get_offers_in_radius({latitude, longitude}, radius)

    render(conn, "job_offers.json", job_offers: job_offers)
  end
end
