defmodule LocalizationWeb.PageView do
  use LocalizationWeb, :view

  def render("job_offers.json", %{job_offers: job_offers}) do
    %{
      count_offer: length(job_offers),
      job_offers: render_many(job_offers, LocalizationWeb.PageView, "job_offer.json")
    }
  end

  def render("job_offer.json", %{
        page: %{
          "name" => name,
          "contract_type" => contract,
          "distance" => distance
        }
      }) do
    %{"name" => name, "contract_type" => contract, "distance" => trunc(distance)}
  end
end
