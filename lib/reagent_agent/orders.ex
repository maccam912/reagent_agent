defmodule ReagentAgent.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias ReagentAgent.Repo

  alias ReagentAgent.Orders.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(opts \\ []) do
    query = from o in Order

    query =
      if preload = opts[:preload] do
        from q in query, preload: ^preload
      else
        query
      end

    Repo.all(query)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id, opts \\ []) do
    query = from o in Order, where: o.id == ^id

    query =
      if preload = opts[:preload] do
        from q in query, preload: ^preload
      else
        query
      end

    Repo.one!(query)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  @doc """
  Fetches all orders for a given site and lot pair within a specified date range.

  ## Parameters

  - site_id: The ID of the site.
  - lot_id: The ID of the lot.
  - date_range: A tuple representing the start and end dates of the range.

  ## Examples

      iex> get_orders_in_range(1, 2, {~D[2023-01-01], ~D[2023-01-31]})
      [%Order{}, ...]

  """
  def get_orders_in_range(site_id, lot_id, {start_date, end_date}) do
    Repo.all(
      from o in Order,
      where: o.site_id == ^site_id and o.lot_id == ^lot_id and o.date >= ^start_date and o.date <= ^end_date,
      order_by: [asc: o.date]
    )
  end

  @doc """
  Finds the next order date for a future order for a given site and lot.

  ## Parameters

  - site_id: The ID of the site.
  - lot_id: The ID of the lot.

  ## Examples

      iex> get_next_order_date(1, 2)
      {:ok, ~D[2023-02-01]}

      iex> get_next_order_date(3, 4)
      {:error, :no_future_orders}

  """
  def get_next_order_date(site_id, lot_id) do
    from(o in Order,
      where: o.site_id == ^site_id and o.lot_id == ^lot_id and o.date > ^Date.utc_today(),
      order_by: [asc: o.date],
      limit: 1
    )
    |> Repo.one()
    |> case do
      nil -> {:error, :no_future_orders}
      order -> {:ok, order.date}
    end
  end

  @doc """
  Finds the earliest order date for a given site and lot.

  ## Parameters

  - site_id: The ID of the site.
  - lot_id: The ID of the lot.

  ## Examples

      iex> get_earliest_order_date(1, 2)
      {:ok, ~D[2023-01-01]}

      iex> get_earliest_order_date(3, 4)
      {:error, :no_orders_found}

  """
  def get_earliest_order_date(site_id, lot_id) do
    query = from o in Order,
             where: o.site_id == ^site_id and o.lot_id == ^lot_id,
             order_by: [asc: o.date],
             limit: 1

    Repo.one(query)
    |> case do
      nil -> {:error, :no_orders_found}
      order -> {:ok, order.date}
    end
  end
end
