
SELECT 
m.first_name,
m.last_name,
m.certification_level,
w.name AS workshop_name,
w.state
FROM mechanics m 
INNER JOIN workshops w ON m.workshop_id = w.id;

SELECT 
vo.fullname AS owner_name,
vo.vehicle_plate_number,
w.name AS workshop_name,
w.state,
c.booking_date,
c.status,
c.conversion_cost_ngn
FROM conversions c 
INNER JOIN workshops w ON c.workshop_id = w.id
INNER JOIN vehicle_owners vo ON c.owner_id = vo.id
ORDER BY c.booking_date DESC;


SELECT
w.name AS workshop_name,
w.state,
COUNT(c.id) AS total_conversions,
SUM(c.conversion_cost_ngn) AS total_revenue_ngn,
AVG(c.conversion_cost_ngn) as average_conversion_cost
FROM workshops w
LEFT JOIN conversions c ON w.id = c.workshop_id
GROUP BY w.id, w.name, w.state
ORDER BY total_revenue_ngn DESC;


SELECT 
    w.name AS workshop_name,
    COUNT(c.id) AS total_conversions,
    SUM(c.conversion_cost_ngn) AS total_revenue_ngn
FROM workshops w
INNER JOIN conversions c ON w.id = c.workshop_id
GROUP BY w.id, w.name
HAVING SUM(c.conversion_cost_ngn) > 900000.00;


WITH workshop_finalcials AS (
    SELECT
        workshop_id,
        COUNT(id) AS completed_jobs,
        SUM(conversion_cost_ngn) AS total_revenue_ngn
    FROM conversions
    WHERE status = 'COMPLETED'
    GROUP BY workshop_id

)
SELECT
    w.name AS workshop_name,
    w.state,
    COALESCE(wf.completed_jobs, 0) AS completed_jobs,
    COALESCE(wf.total_revenue_ngn, 00) AS total_revenue_ngn
FROM workshops w 
LEFT JOIN workshop_finalcials wf ON w.id = wf.workshop_id;


SELECT
    w.state,
    w.name AS workshop_name,
    c.booking_date,
    c.conversion_cost_ngn,
    RANK() OVER (
        PARTITION BY w.state
        ORDER BY c.conversion_cost_ngn DESC
    ) AS state_cost__rank
FROM conversions c
INNER JOIN workshops w ON c.workshop_id = w.id;
