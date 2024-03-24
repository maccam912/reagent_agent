defmodule ReagentAgent.Transfers do
  @moduledoc """
  The Transfers context.
  """

  import Ecto.Query, warn: false
  alias ReagentAgent.Repo

  alias ReagentAgent.Transfers.Transfer

  @doc """
  Returns the list of transfers.

  ## Examples

      iex> list_transfers()
      [%Transfer{}, ...]

  """
  def list_transfers(opts \\ []) do
    query = from t in Transfer

    query =
      if preload = opts[:preload] do
        from q in query, preload: ^preload
      else
        query
      end

    Repo.all(query)
  end

  @doc """
  Gets a single transfer.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer!(123)
      %Transfer{}

      iex> get_transfer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transfer!(id, opts \\ []) do
    query = from t in Transfer, where: t.id == ^id

    query =
      if preload = opts[:preload] do
        from q in query, preload: ^preload
      else
        query
      end

    Repo.one!(query)
  end

  @doc """
  Creates a transfer.

  ## Examples

      iex> create_transfer(%{field: value})
      {:ok, %Transfer{}}

      iex> create_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(attrs \\ %{}) do
    %Transfer{}
    |> Transfer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transfer.

  ## Examples

      iex> update_transfer(transfer, %{field: new_value})
      {:ok, %Transfer{}}

      iex> update_transfer(transfer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transfer(%Transfer{} = transfer, attrs) do
    transfer
    |> Transfer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transfer.

  ## Examples

      iex> delete_transfer(transfer)
      {:ok, %Transfer{}}

      iex> delete_transfer(transfer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transfer(%Transfer{} = transfer) do
    Repo.delete(transfer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transfer changes.

  ## Examples

      iex> change_transfer(transfer)
      %Ecto.Changeset{data: %Transfer{}}

  """
  def change_transfer(%Transfer{} = transfer, attrs \\ %{}) do
    Transfer.changeset(transfer, attrs)
  end

  def get_transfers_after_date(lot_id, date) do
    Repo.all(
      from t in Transfer,
      where: t.lot_id == ^lot_id and t.date > ^date,
      order_by: [asc: t.date]
    )
  end

  @doc """
  Fetches all transfers for a given site and lot pair within a specified date range.

  ## Parameters

  - site_id: The ID of the site.
  - lot_id: The ID of the lot.
  - date_range: A tuple representing the start and end dates of the range.

  ## Examples

      iex> get_transfers_in_range(1, 2, {~D[2023-01-01], ~D[2023-01-31]})
      [%Transfer{}, ...]

  """
  def get_transfers_in_range(site_id, lot_id, {start_date, end_date}) do
    Repo.all(
      from t in Transfer,
      where: (t.from_id == ^site_id or t.to_id == ^site_id) and t.lot_id == ^lot_id and t.date >= ^start_date and t.date <= ^end_date,
      order_by: [asc: t.date]
    )
  end

  @doc """
  Finds the earliest transfer date for a given site and lot.

  ## Parameters

  - site_id: The ID of the site.
  - lot_id: The ID of the lot.

  ## Examples

      iex> get_earliest_transfer_date(1, 2)
      {:ok, ~D[2023-01-01]}

      iex> get_earliest_transfer_date(3, 4)
      {:error, :no_transfers_found}

  """
  def get_earliest_transfer_date(site_id, lot_id) do
    query = from t in Transfer,
             where: (t.from_id == ^site_id or t.to_id == ^site_id) and t.lot_id == ^lot_id,
             order_by: [asc: t.date],
             limit: 1

    Repo.one(query)
    |> case do
      nil -> {:error, :no_transfers_found}
      transfer -> {:ok, transfer.date}
    end
  end
end
