defmodule ReagentAgent.ReportsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReagentAgent.Reports` context.
  """

  @doc """
  Generate a report.
  """
  def report_fixture(attrs \\ %{}) do
    {:ok, report} =
      attrs
      |> Enum.into(%{
        count: 42,
        date: ~D[2024-03-23]
      })
      |> ReagentAgent.Reports.create_report()

    report
  end
end
