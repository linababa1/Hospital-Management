-- Create patients table
CREATE TABLE patients (
    patient_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1),
    date_of_birth DATE,
    contact_number VARCHAR(20),
    address VARCHAR(100),
    registration_date DATE,
    insurance_provider VARCHAR(50),
    insurance_number VARCHAR(20),
    email VARCHAR(100)
);

-- Create doctors table
CREATE TABLE doctors (
    doctor_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
    phone_number VARCHAR(20),
    years_experience INTEGER,
    hospital_branch VARCHAR(50),
    email VARCHAR(100)
);

-- Create appointments table
CREATE TABLE appointments (
    appointment_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR(20),
    doctor_id VARCHAR(20),
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit VARCHAR(50),
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Create treatments table
CREATE TABLE treatments (
    treatment_id VARCHAR(20) PRIMARY KEY,
    appointment_id VARCHAR(20),
    treatment_type VARCHAR(50),
    description VARCHAR(100),
    cost DECIMAL(10, 2),
    treatment_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Create billing table
CREATE TABLE billing (
    bill_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR(20),
    treatment_id VARCHAR(20),
    bill_date DATE,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id)
);
