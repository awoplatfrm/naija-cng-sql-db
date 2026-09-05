
INSERT INTO mechanics (workshop_id, first_name, last_name,phone_number, certification_level)
VALUES (
    (SELECT id FROM workshops WHERE workshop_code = 'CNG-LOS-01'),
    'tunde', 'samuel', +234945672836,'MASTER_LEAD'
),
(
    (SELECT id FROM workshops WHERE workshop_code = 'CNG-LOS-01' ),
    'james','olaiya',+23495435678,'SENIOR'
),
(
    (SELECT id FROM workshops WHERE workshop_code = 'CNG-ABJ-01'),
    'motunrayo','grace',+23490564323,'JUNIOR'
)
RETURNING id,first_name,last_name,certification_level;

INSERT INTO vehicle_owners (fullname, email, vehicle_plate_number)
VALUES 
    ('Babajide Sanwo', 'jide.sanwo@example.com', 'LSD-101-AA'),
    ('Chinedu Eze', 'chinedu.eze@example.com', 'ABJ-452-XY'),
    ('Fatima Bello', 'fatima.bello@example.com', 'PHC-789-GG'),
    ('Afeez Olawale', 'afeez.olawale@example.com', 'KND-331-BB')
RETURNING id, fullname, vehicle_plate_number;


INSERT INTO conversions (workshop_id, owner_id, booking_date,status, conversion_cost_ngn)
VALUES (
        (SELECT id FROM workshops WHERE workshop_code = 'CNG-LOS-01'),
        (SELECT id FROM vehicle_owners WHERE vehicle_plate_number = 'KND-331-BB'),
        '2026-08-28',
        'IN_PROGRESS',
        900000.00
    ),
    (
        (SELECT id FROM workshops WHERE workshop_code = 'CNG-ABJ-01'),
        (SELECT id FROM vehicle_owners WHERE vehicle_plate_number = 'ABJ-452-XY'),
        '2026-09-02',
        'BOOKED',
        950000.00
    ),(
        (SELECT id FROM workshops WHERE workshop_code = 'CNG-PHC-01'),
        (SELECT id FROM vehicle_owners WHERE vehicle_plate_number = 'PHC-789-GG'),
        '2026-09-05',
        'BOOKED',
        880000.00
    );
RETURNING id, workshop_id, owner_id


INSERT INTO conversions (workshop_id,owner_id,booking_date,status,conversion_cost_ngn)
VALUES (
        (SELECT id FROM workshops WHERE workshop_code = 'CNG-LOS-01'),
        (SELECT id FROM vehicle_owners WHERE vehicle_plate_number = 'KND-331-BB'),
        '2026-08-28',
        'COMPLETED',
        100000.00
)
ON CONFLICT (workshop_id,owner_id,booking_date,status)
DO UPDATE SET 
    conversion_cost_ngn = EXCLUDED.conversion_cost_ngn
RETURNING id, booking_date, status, conversion_cost_ngn;