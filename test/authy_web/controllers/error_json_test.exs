defmodule AuthyWeb.ErrorJSONTest do
  use AuthyWeb.ConnCase, async: true

  test "renders 404" do
    assert AuthyWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert AuthyWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
