connection: "default_bigquery_connection"


include: "/views/*.view.lkml"
include: "/dashboards/*.dashboard.lookml"

explore: cruises {
  label: "Executive Cruise Operations & Telemetry"
  description: "Central Explore joining fleet schedules, onboard purchasing transactions, excursion facts, and guest surveys."

  join: cabins {
    type: left_outer
    relationship: one_to_many
    sql_on: ${cruises.ship_code} = ${cabins.ship_code} ;;
  }

  join: onboard_purchases {
    type: left_outer
    relationship: one_to_many
    sql_on: ${cruises.cruise_id} = ${onboard_purchases.cruise_id} ;;
  }

  join: guests {
    type: left_outer
    relationship: many_to_one
    sql_on: ${onboard_purchases.guest_id} = ${guests.guest_id} ;;
  }

  join: shore_excursions {
    type: left_outer
    relationship: one_to_many
    sql_on: ${cruises.cruise_id} = ${shore_excursions.cruise_id} ;;
  }

  join: surveys {
    type: left_outer
    relationship: one_to_many
    sql_on: ${cruises.cruise_id} = ${surveys.cruise_id} ;;
  }

  join: ship_amenities {
    type: left_outer
    relationship: one_to_many
    sql_on: ${cruises.ship_code} = ${ship_amenities.ship_code} ;;
  }

  join: staffing {
    type: left_outer
    relationship: one_to_many
    sql_on: ${cruises.ship_code} = ${staffing.ship_code} ;;
  }
}
