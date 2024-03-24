defmodule ReagentAgentWeb.MetricsLive.Index do
  use ReagentAgentWeb, :live_view
  alias ReagentAgent.Metrics
  alias ReagentAgent.Sites
  alias ReagentAgent.Lots
  alias ReagentAgent.Orders

  @impl true
  def mount(_params, _session, socket) do
    sites = Sites.list_sites()
    lots = Lots.list_lots()
    sites_map = Enum.into(sites, %{}, fn site -> {site.id, site} end)
    lots_map = Enum.into(lots, %{}, fn lot -> {lot.id, lot} end)

    counts = for site <- sites, lot <- lots, into: %{} do
      remaining_boxes = Metrics.calculate_remaining_boxes(lot.id, site.id)

      # Calculate average usage per day
      average_usage_result = Metrics.calculate_average_usage(site.id, lot.id)
      average_usage_per_day = case average_usage_result do
        {:ok, average} -> average
        _ -> 0.0 # Handle error or no report found
      end

      # Calculate total usage before the most recent report
      total_usage_result = Metrics.calculate_usage_before_report(lot.id, site.id)
      total_usage = case total_usage_result do
        {:ok, total} -> total
        _ -> 0.0 # Handle error or no report found
      end

      next_order_result = Orders.get_next_order_date(site.id, lot.id)

      # Ensure remaining_boxes and average_usage_per_day are numbers and average_usage_per_day is not zero
      days_left = case {remaining_boxes, average_usage_per_day} do
        {remaining, average} when is_number(remaining) and is_number(average) and average > 0 ->
          remaining / average
        _ ->
          :infinity
      end

      # Handle both success and error cases for next_order_date
      {next_order_date, days_until_next_order} = case next_order_result do
        {:ok, date} ->
          days_until = Date.diff(date, Date.utc_today())
          {date, days_until}
        {:error, :no_future_orders} ->
          {:no_future_orders, :unknown}
      end

      { {site.id, lot.id}, %{
          remaining_boxes: remaining_boxes,
          average_usage_per_day: average_usage_per_day,
          total_usage: total_usage, # Include total usage
          days_left: days_left,
          next_order_date: next_order_date,
          days_until_next_order: days_until_next_order
        }
      }
    end

    depletion_warnings = Enum.filter(counts, fn {_key, value} ->
      days_until_depletion = value[:days_left] || :infinity
      days_until_next_order = value[:days_until_next_order] || :infinity
      days_until_depletion != :infinity and days_until_next_order != :infinity and days_until_depletion < days_until_next_order
    end)
    |> Enum.map(fn {{site_id, lot_id}, _value} ->
      {sites_map[site_id].name, lots_map[lot_id].reagent <> " - " <> lots_map[lot_id].lot_number}
    end)

    {:ok, assign(socket, sites: sites, lots: lots, counts: counts, depletion_warnings: depletion_warnings)}
  end
end
