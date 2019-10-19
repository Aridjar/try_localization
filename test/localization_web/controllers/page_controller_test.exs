defmodule LocalizationWeb.PageControllerTest do
  use LocalizationWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "GET /v1/get_job_offers", %{conn: conn} do
    conn = get(conn, "/v1/get_job_offers?latitude=48.8659387&longitude=2.34532&radius=10")
    assert %{"job_offers" => [%{} | _]} = json_response(conn, 200)
  end
end
