connection: "default_bigquery_connection"

include: "/views/*.view.lkml"
include: "/dashboards/*.dashboard.lookml"

explore: dim_voyages {
  label: "Executive Cruise Performance & Telemetry"
  description: "Comprehensive enterprise Explore joining voyage capacities, guest spending, and survey sentiment."

  join: fact_touchpoints {
    type: left_outer
    relationship: one_to_many
    sql_on: ${dim_voyages.voyage_id} = ${fact_touchpoints.voyage_id} ;;
  }

  join: dim_sailors {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_touchpoints.sailor_id} = ${dim_sailors.sailor_id} ;;
  }

  join: dim_locations {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_touchpoints.location_id} = ${dim_locations.location_id} ;;
  }

  join: fact_surveys {
    type: left_outer
    relationship: one_to_many
    sql_on: ${dim_voyages.voyage_id} = ${fact_surveys.voyage_id} ;;
  }
}
