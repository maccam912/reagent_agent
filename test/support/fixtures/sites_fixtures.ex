defmodule ReagentAgent.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReagentAgent.Sites` context.
  """

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ReagentAgent.Sites.create_site()

    site
  end
end
