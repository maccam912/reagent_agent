defmodule ReagentAgent.LotsTest do
  use ReagentAgent.DataCase

  alias ReagentAgent.Lots

  describe "lots" do
    alias ReagentAgent.Lots.Lot

    import ReagentAgent.LotsFixtures

    @invalid_attrs %{lot_number: nil, reagent: nil}

    test "list_lots/0 returns all lots" do
      lot = lot_fixture()
      assert Lots.list_lots() == [lot]
    end

    test "get_lot!/1 returns the lot with given id" do
      lot = lot_fixture()
      assert Lots.get_lot!(lot.id) == lot
    end

    test "create_lot/1 with valid data creates a lot" do
      valid_attrs = %{lot_number: "some lot_number", reagent: "some reagent"}

      assert {:ok, %Lot{} = lot} = Lots.create_lot(valid_attrs)
      assert lot.lot_number == "some lot_number"
      assert lot.reagent == "some reagent"
    end

    test "create_lot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lots.create_lot(@invalid_attrs)
    end

    test "update_lot/2 with valid data updates the lot" do
      lot = lot_fixture()
      update_attrs = %{lot_number: "some updated lot_number", reagent: "some updated reagent"}

      assert {:ok, %Lot{} = lot} = Lots.update_lot(lot, update_attrs)
      assert lot.lot_number == "some updated lot_number"
      assert lot.reagent == "some updated reagent"
    end

    test "update_lot/2 with invalid data returns error changeset" do
      lot = lot_fixture()
      assert {:error, %Ecto.Changeset{}} = Lots.update_lot(lot, @invalid_attrs)
      assert lot == Lots.get_lot!(lot.id)
    end

    test "delete_lot/1 deletes the lot" do
      lot = lot_fixture()
      assert {:ok, %Lot{}} = Lots.delete_lot(lot)
      assert_raise Ecto.NoResultsError, fn -> Lots.get_lot!(lot.id) end
    end

    test "change_lot/1 returns a lot changeset" do
      lot = lot_fixture()
      assert %Ecto.Changeset{} = Lots.change_lot(lot)
    end
  end
end
