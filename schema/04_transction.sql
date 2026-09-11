INSERT  INTO conversions (workshop_id, owner_id, booking_date,status, conversion_cost_ngn)
VALUES (
    (SELECT id FROM workshops WHERE workshop_code = 'CNG-LOS-01'),
    (SELECT id FROM vehicle_owners WHERE vehicle_plate_number = 'ABJ-452-XY'),
    '2026-09-19',
    'BOOKED',
    101000.00
);


UPDATE workshops
SET max_daily_limit = max_daily_limit - 1
WHERE workshop_code = 'CNG-LOS-01';

COMMIT;


INSERT  INTO conversions (workshop_id, owner_id, booking_date,status, conversion_cost_ngn)
VALUES (
    (SELECT id FROM workshops WHERE workshop_code = 'CNG-LOS-01'),
    (SELECT id FROM vehicle_owners WHERE vehicle_plate_number = 'ABJ-452-XY'),
    '2026-09-10',
    'BOOKED',
    90000.00
);

BEGIN;

UPDATE workshops
SET max_daily_limit = max_daily_limit + 1
WHERE workshop_code = 'CNG-LOS-01';

ROLLBACK;

BEGIN;
SELECT id, name,max_daily_limit
FROM workshops
WHERE workshop_code = 'CNG-LOS-01'
FOR UPDATE;
INSERT  INTO conversions (workshop_id, owner_id, booking_date,status, conversion_cost_ngn)
VALUES (
    (SELECT id FROM workshops WHERE workshop_code = 'CNG-LOS-01'),
    (SELECT id FROM vehicle_owners WHERE vehicle_plate_number = 'ABJ-452-XY'),
    '2026-09-01',
    'BOOKED',
    100000.00
);
UPDATE workshops
SET max_daily_limit = max_daily_limit - 1
WHERE workshop_code = 'CNG-LOS-01';
COMMIT;


BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT 
w.name AS workshop_name,
COUNT(c.id) AS no_of_bookings,
COALESCE(SUM(c.conversion_cost_ngn),00) AS total_revenue

FROM workshops w
LEFT JOIN conversions c ON w.id = c.workshop_id
GROUP BY w.id, w.name;

COMMIT;