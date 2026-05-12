- dashboard: cruise_executive_overview
  title: "Cruise Fleet Executive Overview"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "High-level executive performance console tracking fleet utilization, financial yields, and overall customer satisfaction."

  filters:
    - name: Ship Code
      title: "Ship Code"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: vv_cruise_analytics
      explore: cruises
      listens_to_filters: []
      field: cruises.ship_code

    - name: Departure Date
      title: "Departure Date"
      type: date_filter
      default_value: "last 90 days"
      allow_multiple_values: true
      required: false
      ui_config:
        type: relative_timeframes
        display: inline

  elements:
    - name: onboard_revenue_scorecard
      title: "Total Onboard Spending Revenue"
      type: single_value
      model: vv_cruise_analytics
      explore: cruises
      measures: [onboard_purchases.total_onboard_revenue]
      filters: {}
      sorts: [onboard_purchases.total_onboard_revenue desc]
      limit: 500
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date

    - name: excursion_revenue_scorecard
      title: "Total Shore Excursion Revenue"
      type: single_value
      model: vv_cruise_analytics
      explore: cruises
      measures: [shore_excursions.total_revenue]
      filters: {}
      sorts: [shore_excursions.total_revenue desc]
      limit: 500
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date

    - name: csat_scorecard
      title: "Average Overall Satisfaction"
      type: single_value
      model: vv_cruise_analytics
      explore: cruises
      measures: [surveys.average_overall_rating]
      filters: {}
      sorts: [surveys.average_overall_rating desc]
      limit: 500
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date

    - name: spend_by_category
      title: "Onboard Revenue by Category"
      type: looker_donut_multi
      model: vv_cruise_analytics
      explore: cruises
      dimensions: [onboard_purchases.category]
      measures: [onboard_purchases.total_onboard_revenue]
      filters: {}
      sorts: [onboard_purchases.total_onboard_revenue desc]
      limit: 500
      show_legend: true
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date

    - name: satisfaction_trend
      title: "Overall Satisfaction Trend Over Time"
      type: looker_line
      model: vv_cruise_analytics
      explore: cruises
      dimensions: [cruises.departure_month]
      measures: [surveys.average_overall_rating]
      filters: {}
      sorts: [cruises.departure_month]
      limit: 500
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      y_axes: [{label: "Satisfaction Score", orientation: left, series: [{id: surveys.average_overall_rating, name: Satisfaction Rating}], showLabels: true, showValues: true, minValue: 1.0, maxValue: 5.0}]
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date
