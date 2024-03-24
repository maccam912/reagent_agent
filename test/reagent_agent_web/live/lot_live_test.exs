defmodule ReagentAgentWeb.LotLiveTest do
  use ReagentAgentWeb.ConnCase

  import Phoenix.LiveViewTest
  import ReagentAgent.LotsFixtures

  @create_attrs %{lot_number: "some lot_number", reagent: "some reagent"}
  @update_attrs %{lot_number: "some updated lot_number", reagent: "some updated reagent"}
  @invalid_attrs %{lot_number: nil, reagent: nil}

  defp create_lot(_) do
    lot = lot_fixture()
    %{lot: lot}
  end

  describe "Index" do
    setup [:create_lot]

    test "lists all lots", %{conn: conn, lot: lot} do
      {:ok, _index_live, html} = live(conn, ~p"/lots")

      assert html =~ "Listing Lots"
      assert html =~ lot.lot_number
    end

    test "saves new lot", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/lots")

      assert index_live |> element("a", "New Lot") |> render_click() =~
               "New Lot"

      assert_patch(index_live, ~p"/lots/new")

      assert index_live
             |> form("#lot-form", lot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#lot-form", lot: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/lots")

      html = render(index_live)
      assert html =~ "Lot created successfully"
      assert html =~ "some lot_number"
    end

    test "updates lot in listing", %{conn: conn, lot: lot} do
      {:ok, index_live, _html} = live(conn, ~p"/lots")

      assert index_live |> element("#lots-#{lot.id} a", "Edit") |> render_click() =~
               "Edit Lot"

      assert_patch(index_live, ~p"/lots/#{lot}/edit")

      assert index_live
             |> form("#lot-form", lot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#lot-form", lot: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/lots")

      html = render(index_live)
      assert html =~ "Lot updated successfully"
      assert html =~ "some updated lot_number"
    end

    test "deletes lot in listing", %{conn: conn, lot: lot} do
      {:ok, index_live, _html} = live(conn, ~p"/lots")

      assert index_live |> element("#lots-#{lot.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#lots-#{lot.id}")
    end
  end

  describe "Show" do
    setup [:create_lot]

    test "displays lot", %{conn: conn, lot: lot} do
      {:ok, _show_live, html} = live(conn, ~p"/lots/#{lot}")

      assert html =~ "Show Lot"
      assert html =~ lot.lot_number
    end

    test "updates lot within modal", %{conn: conn, lot: lot} do
      {:ok, show_live, _html} = live(conn, ~p"/lots/#{lot}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Lot"

      assert_patch(show_live, ~p"/lots/#{lot}/show/edit")

      assert show_live
             |> form("#lot-form", lot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#lot-form", lot: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/lots/#{lot}")

      html = render(show_live)
      assert html =~ "Lot updated successfully"
      assert html =~ "some updated lot_number"
    end
  end
end
