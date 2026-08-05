/* Revenue Leakage Analysis
Question: What is the total revenue lost due to no-shows and cancellations?
 */

SELECT 
    count(appointments.appointment_id) AS total_appointments,
    reason_for_visit,
    status,
    sum(treatments.cost) AS total_revenue_lost,
    Round(avg(treatments.cost), 2) AS average_revenue_lost_per_appointment
FROM appointments
Join treatments ON appointments.appointment_id = treatments.appointment_id
WHERE STATUS IN ('No-show', 'Cancelled')
GROUP BY reason_for_visit, status
ORDER BY total_revenue_lost DESC;

/*
[
  {
    "total_appointments": "15",
    "reason_for_visit": "Consultation",
    "status": "Cancelled",
    "total_revenue_lost": "46702.98",
    "average_revenue_lost_per_appointment": "3113.53"
  },
  {
    "total_appointments": "15",
    "reason_for_visit": "Therapy",
    "status": "No-show",
    "total_revenue_lost": "44146.08",
    "average_revenue_lost_per_appointment": "2943.07"
  },
  {
    "total_appointments": "10",
    "reason_for_visit": "Therapy",
    "status": "Cancelled",
    "total_revenue_lost": "33653.73",
    "average_revenue_lost_per_appointment": "3365.37"
  },
  {
    "total_appointments": "10",
    "reason_for_visit": "Checkup",
    "status": "No-show",
    "total_revenue_lost": "30946.00",
    "average_revenue_lost_per_appointment": "3094.60"
  },
  {
    "total_appointments": "11",
    "reason_for_visit": "Consultation",
    "status": "No-show",
    "total_revenue_lost": "28823.04",
    "average_revenue_lost_per_appointment": "2620.28"
  },
  {
    "total_appointments": "10",
    "reason_for_visit": "Emergency",
    "status": "No-show",
    "total_revenue_lost": "27089.21",
    "average_revenue_lost_per_appointment": "2708.92"
  },
  {
    "total_appointments": "8",
    "reason_for_visit": "Emergency",
    "status": "Cancelled",
    "total_revenue_lost": "26638.76",
    "average_revenue_lost_per_appointment": "3329.85"
  },
  {
    "total_appointments": "10",
    "reason_for_visit": "Follow-up",
    "status": "Cancelled",
    "total_revenue_lost": "24674.79",
    "average_revenue_lost_per_appointment": "2467.48"
  },
  {
    "total_appointments": "8",
    "reason_for_visit": "Checkup",
    "status": "Cancelled",
    "total_revenue_lost": "20374.62",
    "average_revenue_lost_per_appointment": "2546.83"
  },
  {
    "total_appointments": "6",
    "reason_for_visit": "Follow-up",
    "status": "No-show",
    "total_revenue_lost": "11673.48",
    "average_revenue_lost_per_appointment": "1945.58"
  }
]

2️⃣ Key Insights
🔴 Critical Issues:
Consultation Cancellations are your biggest revenue leak

15 cancellations costing $46,703

Average loss of $3,114 per appointment

Recommendation: Implement reminder calls 24-48 hours before consultation appointments

Therapy No-shows are your second biggest problem

15 no-shows costing $44,146

Therapy has the highest no-show count (15)

Recommendation: Consider a deposit or pre-payment policy for therapy sessions

Emergency No-shows are particularly concerning

10 no-shows costing $27,089

Emergency appointments that don't show could indicate patients using other facilities

Recommendation: Investigate why emergency patients don't show up


