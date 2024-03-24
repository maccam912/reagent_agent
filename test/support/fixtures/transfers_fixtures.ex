defmodule ReagentAgent.TransfersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReagentAgent.Transfers` context.
  """

  @doc """
  Generate a transfer.
  """
  def transfer_fixture(attrs \\ %{}) do
    {:ok, transfer} =
      attrs
      |> Enum.into(%{
        count: 42,
        date: ~D[2024-03-23]
      })
      |> ReagentAgent.Transfers.create_transfer()

    transfer
  end
end
