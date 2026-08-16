# Introduction 
This project analyzes a healthcare clinic's appointment data to uncover patterns in patient behavior, identify revenue leakage, and provide actionable insights for improving patient engagement and clinic profitability
# Background
 ### The questions i wanted to answer through my sql queries were:
 1. What is the total revenue lost due to no-shows and cancellations?
 2. Which doctor has lost the most revenue due to no-shows and cancellations?
 3. Which doctors have the highest completion rates, and what is their revenue contribution compared to no-show/cancelled rates?
 4. Who are your most valuable patients, and what are their booking patterns?
# Tools I used
The tools i used for my analysis are:
- SQL: the backbone of my analysis, allowing me to query the database.
- PostgreSQL: The chosen database management system, ideal for handling the hospital management data.
- Git & Github: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking
# The Analysis
## 1.  What is the total revenue lost due to no-shows and cancellations?
```sql
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
```
### Results:
| Rank | Reason for Visit | Status | Lost Appointments | Total Revenue Lost | Avg Loss Per Appointment |
|:----:|------------------|--------|:-----------------:|-------------------:|-------------------------:|
| 1 | Consultation | Cancelled | 15 | **$46,702.98** | $3,113.53 |
| 2 | Therapy | No-show | 15 | **$44,146.08** | $2,943.07 |
| 3 | Therapy | Cancelled | 10 | **$33,653.73** | $3,365.37 |
| 4 | Checkup | No-show | 10 | **$30,946.00** | $3,094.60 |
| 5 | Consultation | No-show | 11 | **$28,823.04** | $2,620.28 |
| 6 | Emergency | No-show | 10 | **$27,089.21** | $2,708.92 |
| 7 | Emergency | Cancelled | 8 | **$26,638.76** | $3,329.85 |
| 8 | Follow-up | Cancelled | 10 | **$24,674.79** | $2,467.48 |
| 9 | Checkup | Cancelled | 8 | **$20,374.62** | $2,546.83 |
| 10 | Follow-up | No-show | 6 | **$11,673.48** | $1,945.58 |
| | **TOTAL** | | **103** | **$282,722.69** | **$2,745.85** |

### Key Insights
**Critical Issues:**
**Consultation Cancellations** are your biggest revenue leak

15 cancellations costing $46,703

Average loss of $3,114 per appointment

**Recommendation:** Implement reminder calls 24-48 hours before consultation appointments

**Therapy** No-shows are your second biggest problem

15 no-shows costing $44,146

Therapy has the highest no-show count (15)

**Recommendation:** Consider a deposit or pre-payment policy for therapy sessions

**Emergency** No-shows are particularly concerning

10 no-shows costing $27,089

Emergency appointments that don't show could indicate patients using other facilities

**Recommendation:** Investigate why emergency patients don't show up

## 2. Which doctor has lost the most revenue due to no-shows and cancellations?

```sql
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
```

### Result:

| Rank | Doctor ID | Doctor Name | Lost Appointments | Total Revenue Lost | Avg Loss Per Appt |
|:----:|:---------:|-------------|:-----------------:|-------------------:|------------------:|
| 1 | D005 | Sarah Taylor | 15 | $48,926.97 | $3,261.80 |
| 2 | D001 | David Taylor | 14 | $36,474.69 | $2,605.34 |
| 3 | D006 | Alex Davis | 12 | $36,045.02 | $3,003.75 |
| 4 | D008 | Linda Brown | 9 | $30,844.54 | $3,427.17 |
| 5 | D003 | Jane Smith | 11 | $29,021.56 | $2,638.32 |
| 6 | D002 | Jane Davis | 9 | $26,408.91 | $2,934.32 |
| 7 | D007 | Robert Davis | 7 | $22,153.05 | $3,164.72 |
| 8 | D009 | Sarah Smith | 10 | $22,140.82 | $2,214.08 |
| 9 | D010 | Linda Wilson | 8 | $21,430.82 | $2,678.85 |
| 10 | D004 | David Jones | 8 | $21,276.31 | $2,659.54 |
| | | **TOTAL** | **103** | **$282,722.69** | **$2,745.85** |

### Insight:
Dr. Sarah Taylor has the highest number of lost appointments (15) and the highest revenue loss at $48,927. Despite her high volume, her average loss per appointment is the second highest at $3,262. This suggests a systemic issue with her patient population or scheduling patterns. Immediate investigation is needed to understand why her patients consistently miss appointments.

Dr. Linda Brown presents a different but equally serious problem. While she has only 9 lost appointments, her average loss per appointment is the highest in the practice at $3,427. This indicates she handles more expensive or complex cases, making each missed appointment significantly more costly. Her total lost revenue of $30,845 demands stricter cancellation policies and waitlist optimization.

## 3. Which doctors have the highest completion rates, and what is their revenue contribution compared to no-show/cancelled rates?

```sql
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
```

| Rank | Doctor | Total Appointments | Completed | Lost | Completion Rate | Total Revenue | Revenue/Appt |
|:----:|--------|:-----------:|:---------:|:----:|:---------------:|--------------:|-------------:|
| 1 | Robert Davis | 12 | 5 | 7 | 41.67% | $39,632.47 | $3,302.71 |
| 2 | Linda Wilson | 13 | 5 | 8 | 38.46% | $30,812.34 | $2,370.18 |
| 3 | Jane Davis | 14 | 5 | 9 | 35.71% | $41,050.42 | $2,932.17 |
| 4 | Jane Smith | 17 | 6 | 11 | 35.29% | $40,859.96 | $2,403.53 |
| 5 | Linda Brown | 13 | 4 | 9 | 30.77% | $43,112.68 | $3,316.36 |
| 6 | David Taylor | 20 | 6 | 14 | 30.00% | $54,708.84 | $2,735.44 |
| 7 | Alex Davis | 17 | 5 | 12 | 29.41% | $53,234.80 | $3,131.46 |
| 8 | David Jones | 11 | 3 | 8 | 27.27% | $31,182.17 | $2,834.74 |
| 9 | Sarah Smith | 13 | 3 | 10 | 23.08% | $26,557.80 | $2,042.91 |
| 10 | Sarah Taylor | 19 | 4 | 15 | 21.05% | $57,671.67 | $3,035.35 |
| | **AVERAGE** | **14.9** | **4.6** | **10.3** | **31.23%** | **$41,882.32** | **$2,810.49** |

### Insight:
1. Dr. Sarah Taylor - The Worst Performer
Metric	Value	Ranking

Completion Rate	21.05%	Lowest (10/10)

Lost Appointments	15	Highest (tied)

Revenue Generated	$57,672	Highest

Revenue/Appt	$3,035	3rd Highest

**Critical Concern:**

**Dr. Sarah Taylor** has the highest revenue per appointment ($3,035) AND the lowest completion rate (21.05%). She generates the most revenue but completes the fewest appointments proportionally.

Impact:

$48,927 lost revenue from missed appointments

15 patients not receiving care

Highest opportunity cost in the practice

**Dr. Sarah Smith** - Underperformer with Lowest Revenue

Metric	Value	Ranking

Completion Rate	23.08%	2nd Lowest

Revenue Generated	$26,558	Lowest

Revenue/Appt	$2,043	Lowest

Total Appointments	13	Average

**Concern:**

Dr. Smith has the lowest revenue per appointment AND the 2nd lowest completion rate. 
This suggests her patients may have lower-acuity conditions or her scheduling might attract more cancellations.

**Dr. Robert Davis** - The Best Performer
Metric	Value	Ranking

Completion Rate	41.67%	Highest

Revenue/Appt	$3,303	Highest

Lost Appointments	7	2nd Lowest

Total Appointments	12	2nd Lowest

## 4. Who are your most valuable patients, and what are their booking patterns?

```sql
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
```
### Results:
| Rank | Patient ID | Patient Name | Insurance Provider | Total Appointments | Completed | Lost | Completion Rate | Total Cost | Avg Cost |
|:----:|:----------:|--------------|--------------------|:-----------:|:---------:|:----:|:---------------:|-----------:|--------------:|
| 1 | P012 | Laura Davis | MedCare Plus | 10 | 0 | 10 | 0% | $30,053.08 | $3,005.31 |
| 2 | P049 | David Moore | MedCare Plus | 7 | 2 | 3 | 29% | $23,554.06 | $3,364.87 |
| 3 | P016 | Michael Taylor | PulseSecure | 7 | 1 | 3 | 14% | $22,967.94 | $3,281.13 |
| 4 | P036 | Michael Wilson | MedCare Plus | 7 | 2 | 2 | 29% | $21,583.56 | $3,083.37 |
| 5 | P005 | David Wilson | MedCare Plus | 8 | 2 | 4 | 25% | $18,609.91 | $2,326.24 |
| 6 | P035 | David Wilson | MedCare Plus | 7 | 1 | 2 | 14% | $18,407.42 | $2,629.63 |
| 7 | P010 | Michael Taylor | WellnessCorp | 6 | 1 | 4 | 17% | $15,929.15 | $2,654.86 |
| 8 | P029 | David Smith | HealthIndia | 7 | 3 | 2 | 43% | $13,324.50 | $1,903.50 |
| 9 | P023 | Linda Johnson | WellnessCorp | 6 | 2 | 3 | 33% | $13,237.69 | $2,206.28 |
| 10 | P026 | John Taylor | MedCare Plus | 6 | 2 | 3 | 33% | $10,487.70 | $1,747.95 |
| | | **TOTAL / AVERAGE** | | **71** | **15** | **36** | **23.4%** | **$188,155.01** | **$2,650.07** |

### Insights

Average Completion Rate	23.4%	🔴 CRITICAL

Revenue Lost	$188,156	🔴 URGENT

Patients with 0% Completion	1	🔴 RED FLAG

Top Insurance (MedCare Plus)	78% Loss Rate	🔴 SYSTEMIC

Revenue per Lost Appt	$3,005 avg	🔴 HIGH

💡 THE REAL STORY

**Laura Davis** - The $30,000 Ghost
10 appointments, 0 completions

Never once showed up

The system failed to catch this after 3 no-shows

**MedCare Plus** - The Problem Payer
78% of their patients miss appointments

They represent 65% of all lost revenue

Insurance issues? High co-pays? Authorization delays?

**Financial Leakage**
$188,156 lost from just 10 patients

Annual projection: $500,000+

Every missed appointment = $3,000+ in lost revenue
# What I learned
# Conclusion