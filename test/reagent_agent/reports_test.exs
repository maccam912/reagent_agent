defmodule ReagentAgent.ReportsTest do
  use ReagentAgent.DataCase

  alias ReagentAgent.Reports

  describe "reports" do
    alias ReagentAgent.Reports.Report

    import ReagentAgent.ReportsFixtures

    @invalid_attrs %{count: nil, date: nil}

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert Reports.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Reports.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      valid_attrs = %{count: 42, date: ~D[2024-03-23]}

      assert {:ok, %Report{} = report} = Reports.create_report(valid_attrs)
      assert report.count == 42
      assert report.date == ~D[2024-03-23]
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      update_attrs = %{count: 43, date: ~D[2024-03-24]}

      assert {:ok, %Report{} = report} = Reports.update_report(report, update_attrs)
      assert report.count == 43
      assert report.date == ~D[2024-03-24]
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_report(report, @invalid_attrs)
      assert report == Reports.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = Reports.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Reports.change_report(report)
    end
  end
end
