defmodule RsPriceDashboardWeb.PageController do
  use RsPriceDashboardWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
