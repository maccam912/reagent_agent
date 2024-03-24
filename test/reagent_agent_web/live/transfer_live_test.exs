defmodule ReagentAgentWeb.TransferLiveTest do
  use ReagentAgentWeb.ConnCase

  import Phoenix.LiveViewTest
  import ReagentAgent.TransfersFixtures

  @create_attrs %{count: 42, date: "2024-03-23"}
  @update_attrs %{count: 43, date: "2024-03-24"}
  @invalid_attrs %{count: nil, date: nil}

  defp create_transfer(_) do
    transfer = transfer_fixture()
    %{transfer: transfer}
  end

  describe "Index" do
    setup [:create_transfer]

    test "lists all transfers", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/transfers")

      assert html =~ "Listing Transfers"
    end

    test "saves new transfer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/transfers")

      assert index_live |> element("a", "New Transfer") |> render_click() =~
               "New Transfer"

      assert_patch(index_live, ~p"/transfers/new")

      assert index_live
             |> form("#transfer-form", transfer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#transfer-form", transfer: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/transfers")

      html = render(index_live)
      assert html =~ "Transfer created successfully"
    end

    test "updates transfer in listing", %{conn: conn, transfer: transfer} do
      {:ok, index_live, _html} = live(conn, ~p"/transfers")

      assert index_live |> element("#transfers-#{transfer.id} a", "Edit") |> render_click() =~
               "Edit Transfer"

      assert_patch(index_live, ~p"/transfers/#{transfer}/edit")

      assert index_live
             |> form("#transfer-form", transfer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#transfer-form", transfer: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/transfers")

      html = render(index_live)
      assert html =~ "Transfer updated successfully"
    end

    test "deletes transfer in listing", %{conn: conn, transfer: transfer} do
      {:ok, index_live, _html} = live(conn, ~p"/transfers")

      assert index_live |> element("#transfers-#{transfer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#transfers-#{transfer.id}")
    end
  end

  describe "Show" do
    setup [:create_transfer]

    test "displays transfer", %{conn: conn, transfer: transfer} do
      {:ok, _show_live, html} = live(conn, ~p"/transfers/#{transfer}")

      assert html =~ "Show Transfer"
    end

    test "updates transfer within modal", %{conn: conn, transfer: transfer} do
      {:ok, show_live, _html} = live(conn, ~p"/transfers/#{transfer}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Transfer"

      assert_patch(show_live, ~p"/transfers/#{transfer}/show/edit")

      assert show_live
             |> form("#transfer-form", transfer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#transfer-form", transfer: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/transfers/#{transfer}")

      html = render(show_live)
      assert html =~ "Transfer updated successfully"
    end
  end
end
