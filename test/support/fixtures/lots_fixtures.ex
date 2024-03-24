defmodule ReagentAgent.LotsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReagentAgent.Lots` context.
  """

  @doc """
  Generate a lot.
  """
  def lot_fixture(attrs \\ %{}) do
    {:ok, lot} =
      attrs
      |> Enum.into(%{
        lot_number: "some lot_number",
        reagent: "some reagent"
      })
      |> ReagentAgent.Lots.create_lot()

    lot
  end
end
