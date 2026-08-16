/*
Question: Who are your most valuable patients (high visit frequency + high treatment costs), and what are their booking patterns?

Why it matters: Helps identify VIP patients for loyalty programs, predicts future revenue, and improves patient retention
*/

WITH patient_visit AS (
    SELECT 
        patients.patient_id,
        first_name || ' ' || last_name AS patient_name,
        patients.insurance_provider,
        COUNT(appointments.appointment_id) AS total_appointments,
        COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_visits,
        COUNT(CASE WHEN status IN ('No-show', 'Cancelled') THEN 1 END) AS lost_visits,
        COUNT(CASE WHEN status = 'Scheduled' THEN 1 END) AS scheduled_visits,
        ROUND(SUM(treatments.cost), 2) AS total_treatment_cost,
        ROUND(AVG(treatments.cost), 2) AS average_treatment_cost,
        MAX(appointments.appointment_date) AS last_visit_date,
        MIN(appointments.appointment_date) AS first_visit_date
    FROM patients
    JOIN appointments ON patients.patient_id = appointments.patient_id
    JOIN treatments ON appointments.appointment_id = treatments.appointment_id
    GROUP BY patients.patient_id, first_name, last_name, patients.insurance_provider
)

SELECT 
    patient_id,
    patient_name,
    insurance_provider,
    total_appointments,
    completed_visits,
    lost_visits,
    scheduled_visits,
    total_treatment_cost,
    average_treatment_cost,
    last_visit_date,
    first_visit_date
FROM patient_visit
ORDER BY total_appointments DESC, completed_visits DESC, total_treatment_cost DESC, average_treatment_cost DESC
LIMIT 10;

/*

[
  {
    "patient_id": "P012",
    "patient_name": "Laura Davis",
    "insurance_provider": "MedCare Plus",
    "total_appointments": "10",
    "completed_visits": "0",
    "lost_visits": "10",
    "scheduled_visits": "0",
    "total_treatment_cost": "30053.08",
    "average_treatment_cost": "3005.31",
    "last_visit_date": "2023-12-26",
    "first_visit_date": "2023-02-05"
  },
  {
    "patient_id": "P005",
    "patient_name": "David Wilson",
    "insurance_provider": "MedCare Plus",
    "total_appointments": "8",
    "completed_visits": "2",
    "lost_visits": "4",
    "scheduled_visits": "2",
    "total_treatment_cost": "18609.91",
    "average_treatment_cost": "2326.24",
    "last_visit_date": "2023-11-14",
    "first_visit_date": "2023-01-01"
  },
  {
    "patient_id": "P029",
    "patient_name": "David Smith",
    "insurance_provider": "HealthIndia",
    "total_appointments": "7",
    "completed_visits": "3",
    "lost_visits": "2",
    "scheduled_visits": "2",
    "total_treatment_cost": "13324.50",
    "average_treatment_cost": "1903.50",
    "last_visit_date": "2023-12-14",
    "first_visit_date": "2023-02-06"
  },
  {
    "patient_id": "P049",
    "patient_name": "David Moore",
    "insurance_provider": "MedCare Plus",
    "total_appointments": "7",
    "completed_visits": "2",
    "lost_visits": "3",
    "scheduled_visits": "2",
    "total_treatment_cost": "23554.06",
    "average_treatment_cost": "3364.87",
    "last_visit_date": "2023-12-26",
    "first_visit_date": "2023-01-02"
  },
  {
    "patient_id": "P036",
    "patient_name": "Michael Wilson",
    "insurance_provider": "MedCare Plus",
    "total_appointments": "7",
    "completed_visits": "2",
    "lost_visits": "2",
    "scheduled_visits": "3",
    "total_treatment_cost": "21583.56",
    "average_treatment_cost": "3083.37",
    "last_visit_date": "2023-11-24",
    "first_visit_date": "2023-03-21"
  },
  {
    "patient_id": "P016",
    "patient_name": "Michael Taylor",
    "insurance_provider": "PulseSecure",
    "total_appointments": "7",
    "completed_visits": "1",
    "lost_visits": "3",
    "scheduled_visits": "3",
    "total_treatment_cost": "22967.94",
    "average_treatment_cost": "3281.13",
    "last_visit_date": "2023-12-16",
    "first_visit_date": "2023-01-28"
  },
  {
    "patient_id": "P035",
    "patient_name": "David Wilson",
    "insurance_provider": "MedCare Plus",
    "total_appointments": "7",
    "completed_visits": "1",
    "lost_visits": "2",
    "scheduled_visits": "4",
    "total_treatment_cost": "18407.42",
    "average_treatment_cost": "2629.63",
    "last_visit_date": "2023-11-15",
    "first_visit_date": "2023-05-22"
  },
  {
    "patient_id": "P023",
    "patient_name": "Linda Johnson",
    "insurance_provider": "WellnessCorp",
    "total_appointments": "6",
    "completed_visits": "2",
    "lost_visits": "3",
    "scheduled_visits": "1",
    "total_treatment_cost": "13237.69",
    "average_treatment_cost": "2206.28",
    "last_visit_date": "2023-12-18",
    "first_visit_date": "2023-02-18"
  },
  {
    "patient_id": "P026",
    "patient_name": "John Taylor",
    "insurance_provider": "MedCare Plus",
    "total_appointments": "6",
    "completed_visits": "2",
    "lost_visits": "3",
    "scheduled_visits": "1",
    "total_treatment_cost": "10487.70",
    "average_treatment_cost": "1747.95",
    "last_visit_date": "2023-10-19",
    "first_visit_date": "2023-01-15"
  },
  {
    "patient_id": "P010",
    "patient_name": "Michael Taylor",
    "insurance_provider": "WellnessCorp",
    "total_appointments": "6",
    "completed_visits": "1",
    "lost_visits": "4",
    "scheduled_visits": "1",
    "total_treatment_cost": "15929.15",
    "average_treatment_cost": "2654.86",
    "last_visit_date": "2023-09-28",
    "first_visit_date": "2023-03-27"
  }
]

 KEY NUMBERS AT A GLANCE
Metric	Value	Status
Average Completion Rate	23.4%	🔴 CRITICAL
Revenue Lost	$188,156	🔴 URGENT
Patients with 0% Completion	1	🔴 RED FLAG
Top Insurance (MedCare Plus)	78% Loss Rate	🔴 SYSTEMIC
Revenue per Lost Appt	$3,005 avg	🔴 HIGH
💡 THE REAL STORY
1. Laura Davis - The $30,000 Ghost
10 appointments, 0 completions

Never once showed up

The system failed to catch this after 3 no-shows

2. MedCare Plus - The Problem Payer
78% of their patients miss appointments

They represent 65% of all lost revenue

Insurance issues? High co-pays? Authorization delays?

3. Financial Leakage
$188,156 lost from just 10 patients

Annual projection: $500,000+

Every missed appointment = $3,000+ in lost revenue

*/
