/* 
Question: Which doctor has lost the most revenue due to no-shows and cancellations?
*/

SELECT 
    doctors.doctor_id,
    doctors.first_name || ' ' || doctors.last_name AS doctor_name,
    count(appointments.appointment_id) AS total_appointments_lost,
    sum(treatments.cost) AS total_revenue_lost,
    Round(avg(treatments.cost), 2) AS average_revenue_lost_per_appointment
FROM appointments
JOIN treatments ON appointments.appointment_id = treatments.appointment_id
JOIN doctors ON appointments.doctor_id = doctors.doctor_id
WHERE STATUS IN ('No-show', 'Cancelled')
GROUP BY doctors.doctor_id, doctors.first_name, doctors.last_name
ORDER BY total_revenue_lost DESC;

/*
[
  {
    "doctor_id": "D005",
    "doctor_name": "Sarah Taylor",
    "total_appointments_lost": "15",
    "total_revenue_lost": "48926.97",
    "average_revenue_lost_per_appointment": "3261.80"
  },
  {
    "doctor_id": "D001",
    "doctor_name": "David Taylor",
    "total_appointments_lost": "14",
    "total_revenue_lost": "36474.69",
    "average_revenue_lost_per_appointment": "2605.34"
  },
  {
    "doctor_id": "D006",
    "doctor_name": "Alex Davis",
    "total_appointments_lost": "12",
    "total_revenue_lost": "36045.02",
    "average_revenue_lost_per_appointment": "3003.75"
  },
  {
    "doctor_id": "D008",
    "doctor_name": "Linda Brown",
    "total_appointments_lost": "9",
    "total_revenue_lost": "30844.54",
    "average_revenue_lost_per_appointment": "3427.17"
  },
  {
    "doctor_id": "D003",
    "doctor_name": "Jane Smith",
    "total_appointments_lost": "11",
    "total_revenue_lost": "29021.56",
    "average_revenue_lost_per_appointment": "2638.32"
  },
  {
    "doctor_id": "D002",
    "doctor_name": "Jane Davis",
    "total_appointments_lost": "9",
    "total_revenue_lost": "26408.91",
    "average_revenue_lost_per_appointment": "2934.32"
  },
  {
    "doctor_id": "D007",
    "doctor_name": "Robert Davis",
    "total_appointments_lost": "7",
    "total_revenue_lost": "22153.05",
    "average_revenue_lost_per_appointment": "3164.72"
  },
  {
    "doctor_id": "D009",
    "doctor_name": "Sarah Smith",
    "total_appointments_lost": "10",
    "total_revenue_lost": "22140.82",
    "average_revenue_lost_per_appointment": "2214.08"
  },
  {
    "doctor_id": "D010",
    "doctor_name": "Linda Wilson",
    "total_appointments_lost": "8",
    "total_revenue_lost": "21430.82",
    "average_revenue_lost_per_appointment": "2678.85"
  },
  {
    "doctor_id": "D004",
    "doctor_name": "David Jones",
    "total_appointments_lost": "8",
    "total_revenue_lost": "21276.31",
    "average_revenue_lost_per_appointment": "2659.54"
  }
]

🔍 KEY INSIGHTS
1. Dr. Sarah Taylor (D005) - Problematic Pattern
15 lost appointments (highest in practice)

$48,927 lost revenue (highest in practice)

$3,262 average loss per appointment (2nd highest)

⚠️ Immediate Action Required:

Investigate why patients miss appointments with Dr. Taylor

Review scheduling patterns - is she overbooked?

Check if her patients are high-risk demographics

Consider pre-payment requirements for her appointments

2. Dr. Linda Brown (D008) - High-Value Leakage
Only 9 lost appointments (tied for 8th)

But $3,427 average loss per appointment (HIGHEST in practice)

$30,845 total lost revenue

⚠️ Immediate Action Required:

Dr. Brown appears to handle more expensive/complex cases

Implement stricter cancellation policies for her patients

Consider waitlist optimization for her slots

Review if her appointment types are more costly

3. Dr. Sarah Smith (D009) - Best Performance
10 lost appointments (middle range)

$2,214 average loss per appointment (LOWEST in practice)

$22,141 total lost - lower than peers with similar lost appointment counts

✅ Identify Best Practices:

What is Dr. Smith doing differently?

Does she have better patient communication?

Review her scheduling/bookings for replicable processes

*/