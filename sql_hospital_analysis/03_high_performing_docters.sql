/*
Question: Which doctors have the highest completion rates, and what is their revenue contribution compared to no-show/cancelled rates?

Why it matters: Identifies top-performing doctors and those needing support, helps with resource allocation and training.
*/

SELECT
    doctors.doctor_id,
    first_name || ' ' || last_name AS doctor_name,
    COUNT(appointments.appointment_id) AS total_appointments,
    COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_appointments,
    COUNT(CASE WHEN status IN ('No-show', 'Cancelled') THEN 1 END) AS lost_appointments,
    ROUND(COUNT(CASE WHEN status = 'Completed' THEN 1 END) * 100.0 / COUNT(appointments.appointment_id), 2) AS completion_rate,
    ROUND(SUM(treatments.cost), 2) AS total_revenue,
    ROUND(AVG(treatments.cost), 2) AS average_revenue_per_appointment
FROM doctors
JOIN appointments ON doctors.doctor_id = appointments.doctor_id
JOIN treatments ON appointments.appointment_id = treatments.appointment_id
WHERE status IN ('Completed', 'No-show', 'Cancelled')
GROUP BY doctors.doctor_id, first_name, last_name
ORDER BY completion_rate DESC;

/*
[
  {
    "doctor_id": "D007",
    "doctor_name": "Robert Davis",
    "total_appointments": "12",
    "completed_appointments": "5",
    "lost_appointments": "7",
    "completion_rate": "41.67",
    "total_revenue": "39632.47",
    "average_revenue_per_appointment": "3302.71"
  },
  {
    "doctor_id": "D010",
    "doctor_name": "Linda Wilson",
    "total_appointments": "13",
    "completed_appointments": "5",
    "lost_appointments": "8",
    "completion_rate": "38.46",
    "total_revenue": "30812.34",
    "average_revenue_per_appointment": "2370.18"
  },
  {
    "doctor_id": "D002",
    "doctor_name": "Jane Davis",
    "total_appointments": "14",
    "completed_appointments": "5",
    "lost_appointments": "9",
    "completion_rate": "35.71",
    "total_revenue": "41050.42",
    "average_revenue_per_appointment": "2932.17"
  },
  {
    "doctor_id": "D003",
    "doctor_name": "Jane Smith",
    "total_appointments": "17",
    "completed_appointments": "6",
    "lost_appointments": "11",
    "completion_rate": "35.29",
    "total_revenue": "40859.96",
    "average_revenue_per_appointment": "2403.53"
  },
  {
    "doctor_id": "D008",
    "doctor_name": "Linda Brown",
    "total_appointments": "13",
    "completed_appointments": "4",
    "lost_appointments": "9",
    "completion_rate": "30.77",
    "total_revenue": "43112.68",
    "average_revenue_per_appointment": "3316.36"
  },
  {
    "doctor_id": "D001",
    "doctor_name": "David Taylor",
    "total_appointments": "20",
    "completed_appointments": "6",
    "lost_appointments": "14",
    "completion_rate": "30.00",
    "total_revenue": "54708.84",
    "average_revenue_per_appointment": "2735.44"
  },
  {
    "doctor_id": "D006",
    "doctor_name": "Alex Davis",
    "total_appointments": "17",
    "completed_appointments": "5",
    "lost_appointments": "12",
    "completion_rate": "29.41",
    "total_revenue": "53234.80",
    "average_revenue_per_appointment": "3131.46"
  },
  {
    "doctor_id": "D004",
    "doctor_name": "David Jones",
    "total_appointments": "11",
    "completed_appointments": "3",
    "lost_appointments": "8",
    "completion_rate": "27.27",
    "total_revenue": "31182.17",
    "average_revenue_per_appointment": "2834.74"
  },
  {
    "doctor_id": "D009",
    "doctor_name": "Sarah Smith",
    "total_appointments": "13",
    "completed_appointments": "3",
    "lost_appointments": "10",
    "completion_rate": "23.08",
    "total_revenue": "26557.80",
    "average_revenue_per_appointment": "2042.91"
  },
  {
    "doctor_id": "D005",
    "doctor_name": "Sarah Taylor",
    "total_appointments": "19",
    "completed_appointments": "4",
    "lost_appointments": "15",
    "completion_rate": "21.05",
    "total_revenue": "57671.67",
    "average_revenue_per_appointment": "3035.35"
  }
]

1. Dr. Sarah Taylor - The Worst Performer
Metric	Value	Ranking
Completion Rate	21.05%	Lowest (10/10)
Lost Appointments	15	Highest (tied)
Revenue Generated	$57,672	Highest
Revenue/Appt	$3,035	3rd Highest
🚨 Critical Concern:
Dr. Sarah Taylor has the highest revenue per appointment ($3,035) AND the lowest completion rate (21.05%). She generates the most revenue but completes the fewest appointments proportionally.

Impact:

$48,927 lost revenue from missed appointments

15 patients not receiving care

Highest opportunity cost in the practice

2. Dr. Sarah Smith - Underperformer with Lowest Revenue
Metric	Value	Ranking
Completion Rate	23.08%	2nd Lowest
Revenue Generated	$26,558	Lowest
Revenue/Appt	$2,043	Lowest
Total Appointments	13	Average
⚠️ Concern:
Dr. Smith has the lowest revenue per appointment AND the 2nd lowest completion rate. This suggests her patients may have lower-acuity conditions or her scheduling might attract more cancellations.

3. Dr. Robert Davis - The Best Performer
Metric	Value	Ranking
Completion Rate	41.67%	Highest
Revenue/Appt	$3,303	Highest
Lost Appointments	7	2nd Lowest
Total Appointments	12	2nd Lowest

*/
