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
      type: looker_pie
      inner_radius: 50
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

    - name: guest_journey_timeline
      title: "Sequential Guest Journey Satisfaction Timeline"
      type: looker_line
      model: vv_cruise_analytics
      explore: cruises
      dimensions: [guest_touchpoint_feedback.stage_name]
      measures: [guest_touchpoint_feedback.average_stage_rating]
      filters: {}
      sorts: [guest_touchpoint_feedback.stage_sort_index]
      limit: 500
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_labels: true
      show_x_axis_ticks: true
      x_axis_scale: auto
      y_axes: [{label: "Average Satisfaction Score", orientation: left, series: [{id: guest_touchpoint_feedback.average_stage_rating, name: Stage Satisfaction}], showLabels: true, showValues: true, minValue: 1.0, maxValue: 5.0}]
      row: 10
      col: 0
      width: 24
      height: 8
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date

    - name: score_imbalance_monitor
      title: "Operational Score Imbalance Monitor (Cleanliness vs. Service)"
      type: looker_line
      model: vv_cruise_analytics
      explore: cruises
      dimensions: [cruises.departure_month, cruises.ship_code]
      measures: [surveys.average_cleanliness_service_variance]
      filters: {}
      sorts: [cruises.departure_month]
      limit: 500
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      reference_lines: [{reference_type: line, line_value: "0", margin_top: deviation, margin_bottom: deviation, label_position: right, color: "#808080", label: Centered Parity}]
      series_colors:
        SEA_EXPLORER: "#E53935"
        OCEAN_QUEEN: "#FB8C00"
        STELLAR_VOYAGER: "#1E88E5"
      row: 18
      col: 0
      width: 12
      height: 8
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date

    - name: key_driver_impact_matrix
      title: "Key Driver Impact Matrix (Frequency vs. Sentiment)"
      type: looker_scatter
      model: vv_cruise_analytics
      explore: cruises
      dimensions: [guest_touchpoint_feedback.extracted_theme]
      measures: [guest_touchpoint_feedback.mention_frequency, guest_touchpoint_feedback.average_sentiment_score]
      filters: {}
      sorts: [guest_touchpoint_feedback.mention_frequency desc]
      limit: 50
      x_axis_gridlines: true
      y_axis_gridlines: true
      show_view_names: false
      y_axes: [{label: "Average Sentiment Impact", orientation: left, series: [{id: guest_touchpoint_feedback.average_sentiment_score, name: Sentiment Impact}], showLabels: true, showValues: true}]
      x_axis_label: "Mention Frequency"
      row: 18
      col: 12
      width: 12
      height: 8
      listen:
        Ship Code: cruises.ship_code
        Departure Date: cruises.departure_date
