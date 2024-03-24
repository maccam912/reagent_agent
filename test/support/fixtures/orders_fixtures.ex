defmodule ReagentAgent.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReagentAgent.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-03-22]
      })
      |> ReagentAgent.Orders.create_order()

    order
  end
end
