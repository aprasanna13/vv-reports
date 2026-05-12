view: dim_sailors {
  sql_table_name: `pr-tftest.virgin_voyage_ds.dim_sailors` ;;
  label: "Sailors (Guests)"

  dimension: sailor_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.sailor_id ;;
    description: "Unique identifier for the Sailor."
    group_label: "IDs"
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
    description: "Sailor's first name."
    group_label: "Demographics"
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    description: "Sailor's last name."
    group_label: "Demographics"
  }

  dimension: full_name {
    type: string
    sql: CONCAT(${first_name}, ' ', ${last_name}) ;;
    description: "Sailor's full name."
    group_label: "Demographics"
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
    description: "Age of the Sailor."
    group_label: "Demographics"
  }

  dimension: loyalty_tier {
    type: string
    sql: ${TABLE}.loyalty_tier ;;
    description: "Loyalty program status tier."
    group_label: "Loyalty & Profile"
  }

  dimension: vibe_archetype {
    type: string
    sql: ${TABLE}.vibe_archetype ;;
    description: "Marketing behavioral vibe archetype."
    group_label: "Loyalty & Profile"
  }

  dimension: cohort_tag {
    type: string
    sql: ${TABLE}.cohort_tag ;;
    description: "Social travel group classification."
    group_label: "Loyalty & Profile"
  }

  dimension: past_voyages_count {
    type: number
    sql: ${TABLE}.past_voyages_count ;;
    description: "Count of past completed voyages."
    group_label: "Loyalty & Profile"
  }

  dimension: starting_loot_usd {
    type: number
    sql: ${TABLE}.starting_loot_usd ;;
    description: "Initial onboard promotional loot (credit) in USD."
    group_label: "Spending & Credit"
  }

  measure: count {
    type: count
    drill_fields: [sailor_id, full_name, loyalty_tier, vibe_archetype]
    description: "Total count of unique Sailors."
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
    value_format_name: decimal_1
    description: "Average age of the Sailors."
  }

  measure: total_starting_loot {
    type: sum
    sql: ${starting_loot_usd} ;;
    value_format_name: usd
    description: "Total allocated starting onboard credit."
  }
}

view: dim_voyages {
  sql_table_name: `pr-tftest.virgin_voyage_ds.dim_voyages` ;;
  label: "Voyages (Cruises)"

  dimension: voyage_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.voyage_id ;;
    description: "Unique identifier for the Voyage."
    group_label: "IDs"
  }

  dimension: ship_name {
    type: string
    sql: ${TABLE}.ship_name ;;
    description: "Name of the vessel."
    group_label: "Vessel Details"
  }

  dimension: itinerary_name {
    type: string
    sql: ${TABLE}.itinerary_name ;;
    description: "Name of the voyage route or itinerary."
    group_label: "Itinerary"
  }

  dimension_group: departure {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.embarkation_date ;;
    description: "Date the voyage sets sail."
  }

  dimension_group: return {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.return_date ;;
    description: "Date the voyage concludes."
  }

  dimension: capacity_max {
    type: number
    sql: ${TABLE}.capacity_max ;;
    description: "Maximum guest capacity of the voyage."
    group_label: "Capacities"
  }

  dimension: guests_booked {
    type: number
    sql: ${TABLE}.guests_booked ;;
    description: "Total number of booked guests."
    group_label: "Capacities"
  }

  measure: count {
    type: count
    drill_fields: [voyage_id, ship_name, itinerary_name, departure_date]
    description: "Total count of unique voyages."
  }

  measure: total_capacity {
    type: sum
    sql: ${capacity_max} ;;
    description: "Sum of available capacity across voyages."
  }

}

view: dim_locations {
  sql_table_name: `pr-tftest.virgin_voyage_ds.dim_locations` ;;
  label: "Onboard Locations"

  dimension: location_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.location_id ;;
    description: "Unique identifier for the onboard location."
    group_label: "IDs"
  }

  dimension: venue_name {
    type: string
    sql: ${TABLE}.venue_name ;;
    description: "Name of the venue or facility."
    group_label: "Venue Info"
  }

  dimension: venue_category {
    type: string
    sql: ${TABLE}.venue_category ;;
    description: "Category of venue (Dining, Wellness, Retail, Entertainment)."
    group_label: "Venue Info"
  }

  dimension: deck_level {
    type: number
    sql: ${TABLE}.deck_level ;;
    description: "Deck level where the venue resides."
    group_label: "Venue Info"
  }

  measure: count {
    type: count
    drill_fields: [location_id, venue_name, venue_category]
    description: "Total count of onboard locations."
  }
}

view: fact_surveys {
  sql_table_name: `pr-tftest.virgin_voyage_ds.fact_surveys` ;;
  label: "Post-Voyage Surveys"

  dimension: survey_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.survey_id ;;
    description: "Unique survey response identifier."
    group_label: "IDs"
  }

  dimension: sailor_id {
    hidden: yes
    type: string
    sql: ${TABLE}.sailor_id ;;
    description: "Foreign key linking to the Sailor."
  }

  dimension: voyage_id {
    hidden: yes
    type: string
    sql: ${TABLE}.voyage_id ;;
    description: "Foreign key linking to the Voyage."
  }

  dimension: nps_score {
    type: number
    sql: ${TABLE}.nps_score ;;
    description: "Net Promoter Score provided by the guest (0-10)."
    group_label: "Scores"
  }

  dimension: overall_satisfaction {
    type: number
    sql: ${TABLE}.overall_satisfaction ;;
    description: "Overall satisfaction rating (0-10)."
    group_label: "Scores"
  }

  dimension: return_intent {
    type: string
    sql: ${TABLE}.return_intent ;;
    description: "Guest intent to return (Yes, Maybe, No)."
    group_label: "Sentiment & Feedback"
  }

  dimension: sentiment_classification {
    type: string
    sql: ${TABLE}.sentiment_classification ;;
    description: "NLP sentiment classification label (Epic, Passive, Detractor)."
    group_label: "Sentiment & Feedback"
  }

  dimension: feedback_verbatim {
    type: string
    sql: ${TABLE}.feedback_verbatim ;;
    description: "Qualitative feedback verbatim comments."
    group_label: "Sentiment & Feedback"
  }

  measure: count {
    type: count
    drill_fields: [survey_id, dim_sailors.full_name, overall_satisfaction, sentiment_classification]
    description: "Total count of submitted surveys."
  }

  measure: average_nps_score {
    type: average
    sql: ${nps_score} ;;
    value_format_name: decimal_2
    description: "Average Net Promoter Score."
  }

  measure: average_overall_satisfaction {
    type: average
    sql: ${overall_satisfaction} ;;
    value_format_name: decimal_2
    description: "Average overall satisfaction rating out of 10."
  }
}

view: fact_touchpoints {
  sql_table_name: `pr-tftest.virgin_voyage_ds.fact_touchpoints` ;;
  label: "Onboard Touchpoints & Spending"

  dimension: touchpoint_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.touchpoint_id ;;
    description: "Unique identifier for the transaction or interaction."
    group_label: "IDs"
  }

  dimension: sailor_id {
    hidden: yes
    type: string
    sql: ${TABLE}.sailor_id ;;
    description: "Foreign key linking to the Sailor."
  }

  dimension: voyage_id {
    hidden: yes
    type: string
    sql: ${TABLE}.voyage_id ;;
    description: "Foreign key linking to the Voyage."
  }

  dimension: location_id {
    hidden: yes
    type: string
    sql: ${TABLE}.location_id ;;
    description: "Foreign key linking to the onboard location."
  }

  dimension_group: interaction {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.interaction_timestamp ;;
    description: "Timestamp when the touchpoint occurred."
  }

  dimension: spend_amount_usd {
    type: number
    sql: ${TABLE}.spend_amount_usd ;;
    description: "Transaction spending amount in USD."
    group_label: "Financials"
  }

  measure: count {
    type: count
    drill_fields: [touchpoint_id, dim_locations.venue_name, spend_amount_usd]
    description: "Total count of onboard touchpoint events."
  }

  measure: total_onboard_revenue {
    type: sum
    sql: ${spend_amount_usd} ;;
    value_format_name: usd
    description: "Total onboard financial revenue generated."
  }

  measure: average_spend_per_transaction {
    type: average
    sql: ${spend_amount_usd} ;;
    value_format_name: usd
    description: "Average spending amount per transaction."
  }
}
