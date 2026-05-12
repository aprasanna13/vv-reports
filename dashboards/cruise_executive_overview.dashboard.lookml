- dashboard: cruise_executive_overview
  title: "Virgin Voyages Executive Overview"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Strategic high-level executive performance dashboard measuring fleet occupancy, financial returns, and guest sentiment."

  filters:
    - name: Ship Name
      title: "Ship Name"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: vv_cruise_analytics
      explore: dim_voyages
      listens_to_filters: []
      field: dim_voyages.ship_name

    - name: Departure Date
      title: "Departure Date"
      type: date_filter
      default_value: "last 90 days"
      allow_multiple_values: true
      required: false
      ui_config:
        type: relative_timeframes
        display: inline

    - name: onboard_revenue_kpi
      title: "Total Onboard Revenue"
      type: single_value
      model: vv_cruise_analytics
      explore: dim_voyages
      measures: [fact_touchpoints.total_onboard_revenue]
      filters: {}
      sorts: [fact_touchpoints.total_onboard_revenue desc]
      limit: 500
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      comparison_type: value
      listen:
        Ship Name: dim_voyages.ship_name
        Departure Date: dim_voyages.departure_date

    - name: csat_nps_kpi
      title: "Average Guest NPS"
      type: single_value
      model: vv_cruise_analytics
      explore: dim_voyages
      measures: [fact_surveys.average_nps_score]
      filters: {}
      sorts: [fact_surveys.average_nps_score desc]
      limit: 500
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      comparison_type: value
      listen:
        Ship Name: dim_voyages.ship_name
        Departure Date: dim_voyages.departure_date

    - name: revenue_by_venue_category
      title: "Revenue by Onboard Venue Category"
      type: looker_donut_multi
      model: vv_cruise_analytics
      explore: dim_voyages
      dimensions: [dim_locations.venue_category]
      measures: [fact_touchpoints.total_onboard_revenue]
      filters: {}
      sorts: [fact_touchpoints.total_onboard_revenue desc]
      limit: 500
      show_legend: true
      listen:
        Ship Name: dim_voyages.ship_name
        Departure Date: dim_voyages.departure_date
