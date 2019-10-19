defmodule LocalizationWeb.PageController do
  use LocalizationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
