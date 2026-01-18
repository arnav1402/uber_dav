SELECT search_path='uber_data';

SHOW search_path

SELECT fact."VendorID", AVG(fare_amount)
FROM fact
GROUP BY fact."VendorID";

SELECT b.payment_type_name, AVG(a.tip_amount)
FROM fact a
JOIN payment b
ON a.payment_type_id = b.payment_type_id
GROUP BY b.payment_type_name

-- Find top 10 pickup locations based on number of trips
SELECT 
    pickup_latitude,
    pickup_longitude,
    COUNT(*) AS trip_count
FROM uber_data.final_tb
GROUP BY pickup_latitude, pickup_longitude
ORDER BY trip_count DESC
LIMIT 10;

-- Find total number of trips by passenger count
SELECT
    passenger_count,
    COUNT(*) AS total_trips
FROM uber_data.final_tb
GROUP BY passenger_count
ORDER BY passenger_count;

-- Find the average fair amount by hour of the day
SELECT
    EXTRACT(HOUR FROM d.tpep_pickup_datetime::timestamp) AS pickup_hour,
    AVG(f.fare_amount) AS avg_fare_amount
FROM uber_data.fact f
JOIN uber_data.datetime d
    ON f.datetime_id = d.datetime_id
GROUP BY EXTRACT(HOUR FROM d.tpep_pickup_datetime::timestamp)
ORDER BY pickup_hour;

DROP TABLE IF EXISTS final_tb;
CREATE TABLE final_tb AS (
SELECT
f.trip_id,
f."VendorID",
d.tpep_pickup_datetime,
d.tpep_dropoff_datetime,
p.passenger_count,
t.trip_distance,
r.rate_code_name,
pick.pickup_latitude,
pick.pickup_longitude,
dro.dropoff_latitude,
dro.dropoff_longitude,
pay.payment_type_name,
f.fare_amount,
f.extra,
f.mta_tax,
f.tip_amount, 
f.tolls_amount, 
f.improvement_surcharge,
f.total_amount

FROM fact f
JOIN datetime d ON f.datetime_id = d.datetime_id
JOIN passenger_count p ON p.passenger_count_id = f.passenger_count_id
JOIN trip_distance t ON t.trip_distance_id = f.trip_id
JOIN rate_code r ON r.rate_code_id = f.rate_code_id
JOIN pickup_loc pick ON pick.pickup_location_id = f.pickup_location_id
JOIN dropoff_loc dro ON dro.dropoff_location_id = f.dropoff_location_id
JOIN payment pay ON pay.payment_type_id = f.payment_type_id
);


SELECT *
FROM final_tb
