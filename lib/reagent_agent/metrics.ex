defmodule ReagentAgent.Metrics do

  alias ReagentAgent.{Reports, Orders, Transfers}

  def calculate_remaining_boxes(lot_id, site_id) do
    report = Reports.get_most_recent_report(lot_id, site_id)

    if report do
      transfers = Transfers.get_transfers_after_date(lot_id, report.date)

      Enum.reduce(transfers, report.count, fn transfer, acc ->
        cond do
          transfer.from_id == site_id -> acc - transfer.count
          transfer.to_id == site_id -> acc + transfer.count
          true -> acc
        end
      end)
    else
      0
    end
  end

  def calculate_average_usage(site_id, lot_id) do
    # Calculate the date range from two years ago to today
    today = Date.utc_today()
    tomorrow = Date.add(today, 1) # Placeholder for tomorrow
    two_years_ago = Date.add(today, -730) # Approximation, considering a year as 365 days

    # Fetch orders and transfers within the specified date range
    orders = Orders.get_orders_in_range(site_id, lot_id, {two_years_ago, today})
    transfers = Transfers.get_transfers_in_range(site_id, lot_id, {two_years_ago, today})

    # Assuming orders are sorted by date, get the date of the first order
    first_order_date = if Enum.empty?(orders), do: tomorrow, else: Enum.at(orders, 0).date

    # Calculate prorated total boxes on the date of the first order
    prorated_total_boxes = Enum.reduce(orders, 0, fn order, acc -> acc + order.count end) +
      Enum.reduce(transfers, 0, fn transfer, acc ->
        cond do
          transfer.to_id == site_id and transfer.date >= first_order_date -> acc + transfer.count
          transfer.from_id == site_id and transfer.date >= first_order_date -> acc - transfer.count
          true -> acc
        end
      end)

    # Get the most recent report
    most_recent_report = Reports.get_most_recent_report(lot_id, site_id)

    # Calculate total boxes used
    total_boxes_used = if most_recent_report do
      most_recent_report.count - prorated_total_boxes
    else
      0 - prorated_total_boxes
    end

    # Calculate the number of days between the first order and the most recent report or today if no report exists
    num_days = if most_recent_report do
      Date.diff(most_recent_report.date, first_order_date) + 1
    else
      Date.diff(today, first_order_date) + 1
    end
    num_days = max(num_days, 1) # Ensure num_days is at least 1

    # Calculate number of boxes used per day
    average_usage_per_day = total_boxes_used / num_days

    -average_usage_per_day
  end

end
