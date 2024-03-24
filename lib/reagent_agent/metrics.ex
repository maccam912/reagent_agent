defmodule ReagentAgent.Metrics do

  alias ReagentAgent.{Reports, Orders, Transfers}

  def calculate_remaining_boxes(lot_id, site_id) do
    report = Reports.get_most_recent_report(lot_id, site_id)

    if report do
      transfers = Transfers.get_transfers_after_date(lot_id, report.date)
      orders = Orders.get_orders_in_range(site_id, lot_id, {report.date, Date.utc_today()})

      Enum.reduce(transfers, report.count, fn transfer, acc ->
        cond do
          transfer.from_id == site_id -> acc - transfer.count
          transfer.to_id == site_id -> acc + transfer.count
          true -> acc
        end
      end)
      |> (fn acc ->
        Enum.reduce(orders, acc, fn order, acc_inner -> acc_inner + order.count end)
      end).()
    else
      0
    end
  end

  def calculate_usage_before_report(lot_id, site_id) do
    most_recent_report = Reports.get_most_recent_report(lot_id, site_id)
    if most_recent_report do
      day_before_report = Date.add(most_recent_report.date, -1)
      orders_sum = dbg(Orders.get_orders_in_range(site_id, lot_id, {~D[1970-01-01], day_before_report})
                  |> Enum.reduce(0, fn order, acc -> acc + order.count end))
      transfers_sum = dbg(Transfers.get_transfers_in_range(site_id, lot_id, {~D[1970-01-01], day_before_report})
                      |> Enum.reduce(0, fn transfer, acc ->
                        cond do
                          transfer.to_id == site_id -> acc + transfer.count
                          transfer.from_id == site_id -> acc - transfer.count
                          true -> acc
                        end
                      end))
      usage_before_report = (orders_sum + transfers_sum) - most_recent_report.count
      {:ok, usage_before_report}
    else
      {:error, :no_report_found}
    end
  end

  def calculate_average_usage(site_id, lot_id) do
    case calculate_usage_before_report(lot_id, site_id) do
      {:ok, usage_before_report} ->
        earliest_order_date = Orders.get_earliest_order_date(site_id, lot_id)
        earliest_transfer_date = Transfers.get_earliest_transfer_date(site_id, lot_id)
        most_recent_report = Reports.get_most_recent_report(lot_id, site_id)

        start_date = case {earliest_order_date, earliest_transfer_date} do
          {{:ok, order_date}, {:ok, transfer_date}} -> Enum.min([order_date, transfer_date])
          {{:ok, order_date}, {:error, :no_transfers_found}} -> order_date
          {{:error, :no_orders_found}, {:ok, transfer_date}} -> transfer_date
          _ -> Date.utc_today() # Fallback if both are not found
        end

        num_days = if most_recent_report do
          Date.diff(most_recent_report.date, start_date) + 1
        else
          1 # Fallback to prevent division by zero
        end

        average_usage_per_day = usage_before_report / num_days
        {:ok, average_usage_per_day}
      {:error, :no_report_found} -> {:error, :no_report_found}
    end
  end

end
