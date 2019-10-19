defmodule LocalizationWeb.Router do
  use LocalizationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LocalizationWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/v1", LocalizationWeb do
    pipe_through :api

    get "/get_job_offers", PageController, :get_job_offers
  end
end
