-- Fix patients table - increase all VARCHAR columns to 250
ALTER TABLE patients 
    ALTER COLUMN patient_id TYPE VARCHAR(250),
    ALTER COLUMN first_name TYPE VARCHAR(250),
    ALTER COLUMN last_name TYPE VARCHAR(250),
    ALTER COLUMN contact_number TYPE VARCHAR(250),
    ALTER COLUMN address TYPE VARCHAR(250),
    ALTER COLUMN insurance_provider TYPE VARCHAR(250),
    ALTER COLUMN insurance_number TYPE VARCHAR(250),
    ALTER COLUMN email TYPE VARCHAR(250);

-- Fix doctors table
ALTER TABLE doctors 
    ALTER COLUMN doctor_id TYPE VARCHAR(250),
    ALTER COLUMN first_name TYPE VARCHAR(250),
    ALTER COLUMN last_name TYPE VARCHAR(250),
    ALTER COLUMN specialization TYPE VARCHAR(250),
    ALTER COLUMN phone_number TYPE VARCHAR(250),
    ALTER COLUMN hospital_branch TYPE VARCHAR(250),
    ALTER COLUMN email TYPE VARCHAR(250);

-- Fix appointments table
ALTER TABLE appointments 
    ALTER COLUMN appointment_id TYPE VARCHAR(250),
    ALTER COLUMN patient_id TYPE VARCHAR(250),
    ALTER COLUMN doctor_id TYPE VARCHAR(250),
    ALTER COLUMN reason_for_visit TYPE VARCHAR(250),
    ALTER COLUMN status TYPE VARCHAR(250);

-- Fix treatments table
ALTER TABLE treatments 
    ALTER COLUMN treatment_id TYPE VARCHAR(250),
    ALTER COLUMN appointment_id TYPE VARCHAR(250),
    ALTER COLUMN treatment_type TYPE VARCHAR(250),
    ALTER COLUMN description TYPE VARCHAR(250);

-- Fix billing table
ALTER TABLE billing 
    ALTER COLUMN bill_id TYPE VARCHAR(250),
    ALTER COLUMN patient_id TYPE VARCHAR(250),
    ALTER COLUMN treatment_id TYPE VARCHAR(250),
    ALTER COLUMN payment_method TYPE VARCHAR(250),
    ALTER COLUMN payment_status TYPE VARCHAR(250);