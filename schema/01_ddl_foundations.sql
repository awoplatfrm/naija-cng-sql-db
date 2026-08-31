

CREATE TABLE if not EXISTS workshops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    workshop_code VARCHAR(20) NOT NULL,
    state VARCHAR(50) NOT NULL,
    max_daily_limit INT NOT NULL DEFAULT 5 CHECK ( max_daily_limit > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

);


CREATE TABLE IF NOT EXISTS mechanics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workshop_id UUID NOT NULL REFERENCES workshops(id) ON DELETE RESTRICT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    certification_level VARCHAR(20) NOT NULL CHECK (certification_level IN ('JUNIOR', 'SENIOR', 'MASTER_LEAD')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS vehicle_owners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fullname VARCHAR(100) NOT null,
    email VARCHAR(100) NOT NULL UNIQUE,
    vehicle_plate_number VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS conversions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workshop_id UUID NOT NULL REFERENCES workshops(id) ON DELETE CASCADE,
    owner_id UUID NOT NULL REFERENCES vehicle_owners(id) ON DELETE CASCADE,
    booking_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'BOOKED' CHECK ( status IN ('BOOKED','IN_PROGRESS','COMPLETED','CANCELLED')),
    conversion_cost_ngn NUMERIC(12,2) NOT NULL check (conversion_cost_ngn >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    constraint uq_owner_workshop_date UNIQUE (workshop_id,owner_id,booking_date)
);



