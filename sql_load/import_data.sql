-- Import patients
COPY patients(patient_id, first_name, last_name, gender, date_of_birth, contact_number, address, registration_date, insurance_provider, insurance_number, email)
FROM 'C:\Analytics Engineer\SQL PROJECTS\Hospital Management\data\patients.csv'
DELIMITER ','
CSV HEADER;

-- Import doctors
COPY doctors(doctor_id, first_name, last_name, specialization, phone_number, years_experience, hospital_branch, email)
FROM 'C:\Analytics Engineer\SQL PROJECTS\Hospital Management\data\doctors.csv'
DELIMITER ','
CSV HEADER;

-- Import appointments
COPY appointments(appointment_id, patient_id, doctor_id, appointment_date, appointment_time, reason_for_visit, status)
FROM 'C:\Analytics Engineer\SQL PROJECTS\Hospital Management\data\appointments.csv'
DELIMITER ','
CSV HEADER;

-- Import treatments
COPY treatments(treatment_id, appointment_id, treatment_type, description, cost, treatment_date)
FROM 'C:\Analytics Engineer\SQL PROJECTS\Hospital Management\data\treatments.csv'
DELIMITER ','
CSV HEADER;

-- Import billing
COPY billing(bill_id, patient_id, treatment_id, bill_date, amount, payment_method, payment_status)
FROM 'C:\Analytics Engineer\SQL PROJECTS\Hospital Management\data\billing.csv'
DELIMITER ','
CSV HEADER;

select * from patients;