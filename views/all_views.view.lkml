view: guests {
  sql_table_name: `pr-tftest.vv_ds.guests` ;;
  label: "Guests"

  dimension: guest_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.guest_id ;;
    description: "Unique identifier for the guest."
    group_label: "IDs"
  }

  dimension: full_name {
    type: string
    sql: ${TABLE}.full_name ;;
    description: "Full name of the guest."
    group_label: "Demographics"
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
    description: "Age of the guest."
    group_label: "Demographics"
  }

  dimension: loyalty_tier {
    type: string
    sql: ${TABLE}.loyalty_tier ;;
    description: "Loyalty program tier (Bronze, Silver, Gold, Platinum)."
    group_label: "Loyalty"
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
    description: "Country of residence."
    group_label: "Demographics"
  }

  measure: count {
    type: count
    drill_fields: [guest_id, full_name, loyalty_tier, country]
    description: "Total count of unique guests."
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
    value_format_name: decimal_1
    description: "Average age of the guests."
  }
}

view: cabins {
  sql_table_name: `pr-tftest.vv_ds.cabins` ;;
  label: "Cabins"

  dimension: cabin_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.cabin_id ;;
    description: "Unique identifier for the cabin."
    group_label: "IDs"
  }

  dimension: ship_code {
    type: string
    sql: ${TABLE}.ship_code ;;
    description: "Code identifying the cruise ship."
    group_label: "Ship Details"
  }

  dimension: deck_number {
    type: number
    sql: ${TABLE}.deck_number ;;
    description: "Deck number where the cabin is located."
    group_label: "Cabin Specs"
  }

  dimension: cabin_category {
    type: string
    sql: ${TABLE}.cabin_category ;;
    description: "Category of the cabin (Interior, Oceanview, Balcony, Suite)."
    group_label: "Cabin Specs"
  }

  dimension: capacity {
    type: number
    sql: ${TABLE}.capacity ;;
    description: "Maximum guest capacity of the cabin."
    group_label: "Cabin Specs"
  }

  measure: count {
    type: count
    drill_fields: [cabin_id, ship_code, deck_number, cabin_category]
    description: "Total count of physical cabins."
  }

  measure: total_capacity {
    type: sum
    sql: ${capacity} ;;
    description: "Total guest capacity across all cabins."
  }
}

view: cruises {
  sql_table_name: `pr-tftest.vv_ds.cruises` ;;
  label: "Cruises (Sailings)"

  dimension: cruise_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.cruise_id ;;
    description: "Unique identifier for the cruise sailing."
    group_label: "IDs"
  }

  dimension: ship_code {
    type: string
    sql: ${TABLE}.ship_code ;;
    description: "Code identifying the cruise ship."
    group_label: "Sailing Details"
  }

  dimension: itinerary_name {
    type: string
    sql: ${TABLE}.itinerary_name ;;
    description: "Name of the itinerary or route."
    group_label: "Sailing Details"
  }

  dimension_group: departure {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.departure_date ;;
    description: "Date the cruise departs."
  }

  dimension_group: return {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.return_date ;;
    description: "Date the cruise returns."
  }

  measure: count {
    type: count
    drill_fields: [cruise_id, ship_code, itinerary_name, departure_date]
    description: "Total count of unique cruise sailings."
  }
}

view: shore_excursions {
  sql_table_name: `pr-tftest.vv_ds.shore_excursions` ;;
  label: "Shore Excursions"

  dimension: excursion_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.excursion_id ;;
    description: "Unique identifier for the shore excursion booking."
    group_label: "IDs"
  }

  dimension: cruise_id {
    hidden: yes
    type: string
    sql: ${TABLE}.cruise_id ;;
    description: "Associated cruise sailing ID."
  }

  dimension: guest_id {
    hidden: yes
    type: string
    sql: ${TABLE}.guest_id ;;
    description: "Guest who booked the excursion."
  }

  dimension: excursion_name {
    type: string
    sql: ${TABLE}.excursion_name ;;
    description: "Name of the shore excursion."
    group_label: "Excursion Info"
  }

  dimension_group: booking {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.booking_date ;;
    description: "Date the excursion was booked."
  }

  dimension: price_usd {
    type: number
    sql: ${TABLE}.price_usd ;;
    description: "Price paid for the excursion in USD."
    group_label: "Financials"
  }

  dimension: satisfaction_score {
    type: number
    sql: ${TABLE}.satisfaction_score ;;
    description: "Guest satisfaction rating from 1 to 5."
    group_label: "Ratings"
  }

  measure: count {
    type: count
    drill_fields: [excursion_id, excursion_name, booking_date, price_usd]
    description: "Total count of excursion bookings."
  }

  measure: total_revenue {
    type: sum
    sql: ${price_usd} ;;
    value_format_name: usd
    description: "Total revenue generated from shore excursions."
  }

  measure: average_satisfaction {
    type: average
    sql: ${satisfaction_score} ;;
    value_format_name: decimal_2
    description: "Average guest satisfaction score for excursions."
  }
}

view: onboard_purchases {
  sql_table_name: `pr-tftest.vv_ds.onboard_purchases` ;;
  label: "Onboard Purchases"

  dimension: purchase_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.purchase_id ;;
    description: "Unique identifier for the onboard transaction."
    group_label: "IDs"
  }

  dimension: cruise_id {
    hidden: yes
    type: string
    sql: ${TABLE}.cruise_id ;;
    description: "Associated cruise sailing ID."
  }

  dimension: guest_id {
    hidden: yes
    type: string
    sql: ${TABLE}.guest_id ;;
    description: "Guest who made the purchase."
  }

  dimension_group: transaction {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.transaction_timestamp ;;
    description: "Timestamp when the purchase occurred."
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    description: "Category of purchase (Dining, Spa, Casino, Beverage, Retail)."
    group_label: "Transaction Info"
  }

  dimension: amount_usd {
    type: number
    sql: ${TABLE}.amount_usd ;;
    description: "Transaction amount in USD."
    group_label: "Financials"
  }

  measure: count {
    type: count
    drill_fields: [purchase_id, category, transaction_time, amount_usd]
    description: "Total number of onboard spending transactions."
  }

  measure: total_onboard_revenue {
    type: sum
    sql: ${amount_usd} ;;
    value_format_name: usd
    description: "Total financial revenue from onboard spending."
  }

  measure: average_spend_per_transaction {
    type: average
    sql: ${amount_usd} ;;
    value_format_name: usd
    description: "Average transaction spend amount."
  }
}

view: ship_amenities {
  sql_table_name: `pr-tftest.vv_ds.ship_amenities` ;;
  label: "Ship Amenities"

  dimension: amenity_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.amenity_id ;;
    description: "Unique identifier for the ship amenity."
    group_label: "IDs"
  }

  dimension: ship_code {
    type: string
    sql: ${TABLE}.ship_code ;;
    description: "Code identifying the cruise ship."
    group_label: "Facility Info"
  }

  dimension: amenity_name {
    type: string
    sql: ${TABLE}.amenity_name ;;
    description: "Name of the facility or amenity."
    group_label: "Facility Info"
  }

  dimension: amenity_type {
    type: string
    sql: ${TABLE}.amenity_type ;;
    description: "Type of amenity (Dining, Entertainment, Relaxation)."
    group_label: "Facility Info"
  }

  dimension: is_operational {
    type: yesno
    sql: ${TABLE}.is_operational ;;
    description: "Whether the amenity is fully operational."
    group_label: "Facility Info"
  }

  measure: count {
    type: count
    drill_fields: [amenity_id, amenity_name, amenity_type, is_operational]
    description: "Total count of permanent ship amenities."
  }
}

view: staffing {
  sql_table_name: `pr-tftest.vv_ds.staffing` ;;
  label: "Staffing"

  dimension: staff_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.staff_id ;;
    description: "Unique staff identifier."
    group_label: "IDs"
  }

  dimension: ship_code {
    type: string
    sql: ${TABLE}.ship_code ;;
    description: "Code identifying the cruise ship."
    group_label: "Crew Info"
  }

  dimension: role {
    type: string
    sql: ${TABLE}.role ;;
    description: "Job title or role on the ship."
    group_label: "Crew Info"
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
    description: "Shipboard department (Hospitality, Deck, Engine, Entertainment)."
    group_label: "Crew Info"
  }

  measure: count {
    type: count
    drill_fields: [staff_id, role, department]
    description: "Total count of crew members."
  }
}

view: surveys {
  sql_table_name: `pr-tftest.vv_ds.surveys` ;;
  label: "Guest Surveys"

  dimension: survey_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.survey_id ;;
    description: "Unique survey response identifier."
    group_label: "IDs"
  }

  dimension: cruise_id {
    hidden: yes
    type: string
    sql: ${TABLE}.cruise_id ;;
    description: "Associated cruise sailing ID."
  }

  dimension: guest_id {
    hidden: yes
    type: string
    sql: ${TABLE}.guest_id ;;
    description: "Guest who submitted the survey."
  }

  dimension_group: submission {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.submission_date ;;
    description: "Date the survey was submitted."
  }

  dimension: overall_rating {
    type: number
    sql: ${TABLE}.overall_rating ;;
    description: "Overall satisfaction score from 1 to 5."
    group_label: "Ratings"
  }

  dimension: service_rating {
    type: number
    sql: ${TABLE}.service_rating ;;
    description: "Service quality rating from 1 to 5."
    group_label: "Ratings"
  }

  dimension: cleanliness_rating {
    type: number
    sql: ${TABLE}.cleanliness_rating ;;
    description: "Cleanliness rating from 1 to 5."
    group_label: "Ratings"
  }

  dimension: feedback_text {
    type: string
    sql: ${TABLE}.feedback_text ;;
    description: "Optional qualitative comments from the guest."
    group_label: "Feedback"
  }

  measure: count {
    type: count
    drill_fields: [survey_id, overall_rating, submission_date]
    description: "Total count of submitted surveys."
  }

  measure: average_overall_rating {
    type: average
    sql: ${overall_rating} ;;
    value_format_name: decimal_2
    description: "Average overall satisfaction score."
  }

  measure: average_service_rating {
    type: average
    sql: ${service_rating} ;;
    value_format_name: decimal_2
    description: "Average service quality score."
  }

  measure: average_cleanliness_rating {
    type: average
    sql: ${cleanliness_rating} ;;
    value_format_name: decimal_2
    description: "Average cleanliness rating."
  }

  dimension: cleanliness_service_variance {
    type: number
    sql: ${cleanliness_rating} - ${service_rating} ;;
    description: "Centered variance between physical cleanliness and staff service ratings."
    group_label: "Ratings"
  }

  measure: average_cleanliness_service_variance {
    type: average
    sql: ${cleanliness_service_variance} ;;
    value_format_name: decimal_2
    description: "Average cleanliness vs. service variance."
  }
}

view: guest_touchpoint_feedback {
  sql_table_name: `pr-tftest.vv_ds.guest_touchpoint_feedback` ;;
  label: "Guest Touchpoint Feedback"

  dimension: feedback_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.feedback_id ;;
    description: "Unique identifier for the touchpoint feedback record."
    group_label: "IDs"
  }

  dimension: guest_id {
    hidden: yes
    type: string
    sql: ${TABLE}.guest_id ;;
    description: "Associated guest identifier."
  }

  dimension: cruise_id {
    hidden: yes
    type: string
    sql: ${TABLE}.cruise_id ;;
    description: "Associated cruise sailing identifier."
  }

  dimension: stage_name {
    type: string
    sql: ${TABLE}.stage_name ;;
    description: "Name of the vacation lifecycle stage."
    group_label: "Lifecycle Stage"
  }

  dimension: stage_sort_index {
    type: number
    sql: ${TABLE}.stage_sort_index ;;
    description: "Chronological integer sorting index for the stage (1 to 6)."
    group_label: "Lifecycle Stage"
  }

  dimension: rating {
    type: number
    sql: ${TABLE}.rating ;;
    description: "Satisfaction rating for this specific stage (1 to 5)."
    group_label: "Ratings"
  }

  dimension: extracted_theme {
    type: string
    sql: ${TABLE}.extracted_theme ;;
    description: "Qualitative thematic classification extracted from verbatim feedback."
    group_label: "Feedback"
  }

  dimension: feedback_text {
    type: string
    sql: ${TABLE}.feedback_text ;;
    description: "Raw verbatim text comment provided by the guest."
    group_label: "Feedback"
  }

  dimension: sentiment_score {
    type: number
    sql: ${TABLE}.sentiment_score ;;
    description: "Correlated sentiment impact score from -1.0 to 1.0."
    group_label: "Feedback"
  }

  measure: count {
    type: count
    drill_fields: [feedback_id, stage_name, rating, extracted_theme]
    description: "Total count of feedback records."
  }

  measure: average_stage_rating {
    type: average
    sql: ${rating} ;;
    value_format_name: decimal_2
    description: "Average satisfaction rating per lifecycle stage."
  }

  measure: average_sentiment_score {
    type: average
    sql: ${sentiment_score} ;;
    value_format_name: decimal_2
    description: "Average sentiment score."
  }

  measure: mention_frequency {
    type: count
    description: "Frequency of specific theme mentions."
  }
}
