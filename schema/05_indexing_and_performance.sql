
EXPLAIN ANALYZE
SELECT * FROM vehicle_owners
WHERE vehicle_plate_number = 'LSD-101-AA';

--indexing strategies and query performance
--single column B-TREE index on workshop state
CREATE INDEX idx_workshop_state ON workshops(state);

--composite index on conversion (status + booking Date)
--optimizes query filtering by active jobs ordered by date

CREATE INDEX idx_conversion_status_date ON conversions (status,booking_date DESC);

--partial indexing (index only uncompleted jobs)
-- Extremely small disk size, highly effective for active queue endpoints
CREATE INDEX idx_conversion_active ON conversions(workshop_id,booking_date)
WHERE status IN ('BOOKED', 'IN_PROGRESS');

EXPLAIN ANALYZE
SELECT * 
FROM conversions
WHERE status = 'BOOKED'
ORDER BY booking_date DESC;