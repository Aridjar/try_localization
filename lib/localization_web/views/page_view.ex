defmodule LocalizationWeb.PageView do
  use LocalizationWeb, :view

  def render("job_offers.json", %{job_offers: job_offers}) do
    %{job_offers: render_many(job_offers, LocalizationWeb.PageView, "job_offer.json")}
  end

  def render("job_offer.json", _job_offer) do
    %{test: "test"}
  end
end
