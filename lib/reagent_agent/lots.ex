defmodule ReagentAgent.Lots do
  @moduledoc """
  The Lots context.
  """

  import Ecto.Query, warn: false
  alias ReagentAgent.Repo

  alias ReagentAgent.Lots.Lot

  @doc """
  Returns the list of lots.

  ## Examples

      iex> list_lots()
      [%Lot{}, ...]

  """
  def list_lots do
    Repo.all(Lot)
  end

  @doc """
  Gets a single lot.

  Raises `Ecto.NoResultsError` if the Lot does not exist.

  ## Examples

      iex> get_lot!(123)
      %Lot{}

      iex> get_lot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lot!(id), do: Repo.get!(Lot, id)

  @doc """
  Creates a lot.

  ## Examples

      iex> create_lot(%{field: value})
      {:ok, %Lot{}}

      iex> create_lot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lot(attrs \\ %{}) do
    %Lot{}
    |> Lot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lot.

  ## Examples

      iex> update_lot(lot, %{field: new_value})
      {:ok, %Lot{}}

      iex> update_lot(lot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lot(%Lot{} = lot, attrs) do
    lot
    |> Lot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lot.

  ## Examples

      iex> delete_lot(lot)
      {:ok, %Lot{}}

      iex> delete_lot(lot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lot(%Lot{} = lot) do
    Repo.delete(lot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lot changes.

  ## Examples

      iex> change_lot(lot)
      %Ecto.Changeset{data: %Lot{}}

  """
  def change_lot(%Lot{} = lot, attrs \\ %{}) do
    Lot.changeset(lot, attrs)
  end
end
