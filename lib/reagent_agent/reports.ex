defmodule ReagentAgent.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias ReagentAgent.Repo

  alias ReagentAgent.Reports.Report

  @doc """
  Returns the list of reports.

  ## Examples

      iex> list_reports()
      [%Report{}, ...]

  """
  def list_reports(opts \\ []) do
    query = from r in Report

    query =
      if preload = opts[:preload] do
        from q in query, preload: ^preload
      else
        query
      end

    Repo.all(query)
  end


  @doc """
  Gets a single report.

  Raises `Ecto.NoResultsError` if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

      iex> get_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report!(id, opts \\ []) do
    query = from r in Report, where: r.id == ^id

    query =
      if preload = opts[:preload] do
        from q in query, preload: ^preload
      else
        query
      end

    Repo.one!(query)
  end

  @doc """
  Creates a report.

  ## Examples

      iex> create_report(%{field: value})
      {:ok, %Report{}}

      iex> create_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report.

  ## Examples

      iex> update_report(report, %{field: new_value})
      {:ok, %Report{}}

      iex> update_report(report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report(%Report{} = report, attrs) do
    report
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a report.

  ## Examples

      iex> delete_report(report)
      {:ok, %Report{}}

      iex> delete_report(report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_report(%Report{} = report) do
    Repo.delete(report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report changes.

  ## Examples

      iex> change_report(report)
      %Ecto.Changeset{data: %Report{}}

  """
  def change_report(%Report{} = report, attrs \\ %{}) do
    Report.changeset(report, attrs)
  end

  def get_most_recent_report(lot_id, site_id) do
    Repo.one(
      from r in Report,
      where: r.lot_id == ^lot_id and r.site_id == ^site_id,
      order_by: [desc: r.date],
      limit: 1
    )
  end

  @doc """
  Fetches the last N reports for a given site and lot pair.

  ## Parameters

  - site_id: The ID of the site.
  - lot_id: The ID of the lot.
  - n: The number of reports to fetch.

  ## Examples

      iex> get_last_n_reports(1, 2, 5)
      [%Report{}, %Report{}, %Report{}, %Report{}, %Report{}]

  """
  def get_last_n_reports(site_id, lot_id, n) do
    Repo.all(
      from r in Report,
      where: r.site_id == ^site_id and r.lot_id == ^lot_id,
      order_by: [desc: r.date],
      limit: ^n
    )
  end
end
