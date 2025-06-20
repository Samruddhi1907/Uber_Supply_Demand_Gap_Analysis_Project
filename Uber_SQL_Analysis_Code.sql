-- Creating uber_data_cleaned table
CREATE TABLE uber_data_cleaned (
    `Request id` INT,
    `Pickup point` VARCHAR(50),
    `Driver id` INT,
    `Status` VARCHAR(50),
    `Request timestamp` DATETIME,
    `Drop timestamp` DATETIME NULL,
    `Request Hour` INT,
    `Request Day of Week` VARCHAR(20),
    `Trip Duration (minutes)` DECIMAL(20, 15) 
);

-- Loading uber_requests_cleaned.csv file exported after cleaning with python from Colab Notebook into table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/uber_requests_cleaned.csv' 
INTO TABLE uber_data_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(
    `Request id`,
    `Pickup point`,
    `Driver id`,
    `Status`,
    `Request timestamp`,
    @dummy_drop_timestamp,
    `Request Hour`,
    `Request Day of Week`,
    @dummy_trip_duration
)
SET
    `Drop timestamp` = NULLIF(@dummy_drop_timestamp, ''),
    `Trip Duration (minutes)` = NULLIF(@dummy_trip_duration, '');
-- Query Output
Query OK, 6745 rows affected (0.19 sec)
Records: 6745  Deleted: 0  Skipped: 0  Warnings: 0

-- Query : Overall Request Status Distribution
SELECT
    Status,
    COUNT(*) AS NumberOfRequests
FROM
    uber_data_cleaned
GROUP BY
    Status
ORDER BY
    NumberOfRequests DESC;
-- Query Output
+-------------------+-----------------+
| Status            | NumberOfRequests|
+-------------------+-----------------+
| Trip completed    | 2831            |
| No cars available | 2650            |
| Cancelled         | 1264            |
+-------------------+-----------------+
3 rows in set (0.02 sec)

-- Query : Request Status Distribution by Pickup Point
SELECT
    `Pickup point`,
    Status,
    COUNT(*) AS NumberOfRequests
FROM
    uber_data_cleaned
GROUP BY
    `Pickup point`,
    Status
ORDER BY
    `Pickup point`,
    NumberOfRequests DESC;
-- Query Output
+--------------+-------------------+-----------------+
| Pickup point | Status            | NumberOfRequests|
+--------------+-------------------+-----------------+
| Airport      | No cars available | 1713            |
| Airport      | Trip completed    | 1327            |
| Airport      | Cancelled         | 198             |
| City         | Trip completed    | 1504            |
| City         | Cancelled         | 1066            |
| City         | No cars available | 937             |
+--------------+-------------------+-----------------+
6 rows in set (0.03 sec)

-- Query : Hourly Demand and Supply Patterns (Overall)
SELECT
    HOUR(`Request timestamp`) AS RequestHour,
    SUM(CASE WHEN Status = 'Trip completed' THEN 1 ELSE 0 END) AS TripCompleted,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
    SUM(CASE WHEN Status = 'No cars available' THEN 1 ELSE 0 END) AS NoCarsAvailable,
    COUNT(*) AS TotalRequests
FROM
    uber_data_cleaned
GROUP BY
    RequestHour
ORDER BY
    RequestHour;
-- Query Output
+-------------+---------------+-----------+-----------------+---------------+
| RequestHour | TripCompleted | Cancelled | NoCarsAvailable | TotalRequests |
+-------------+---------------+-----------+-----------------+---------------+
| 0           | 40            | 3         | 56              | 99            |
| 1           | 25            | 4         | 56              | 85            |
| 2           | 37            | 5         | 57              | 99            |
| 3           | 34            | 2         | 56              | 92            |
| 4           | 78            | 51        | 74              | 203           |
| 5           | 185           | 176       | 84              | 445           |
| 6           | 167           | 145       | 86              | 398           |
| 7           | 174           | 169       | 63              | 406           |
| 8           | 155           | 178       | 90              | 423           |
| 9           | 173           | 175       | 83              | 431           |
| 10          | 116           | 62        | 65              | 243           |
| 11          | 115           | 15        | 41              | 171           |
| 12          | 121           | 19        | 44              | 184           |
| 13          | 89            | 18        | 53              | 160           |
| 14          | 88            | 11        | 37              | 136           |
| 15          | 102           | 21        | 48              | 171           |
| 16          | 91            | 22        | 46              | 159           |
| 17          | 151           | 35        | 232             | 418           |
| 18          | 164           | 24        | 322             | 510           |
| 19          | 166           | 24        | 283             | 473           |
| 20          | 161           | 41        | 290             | 492           |
| 21          | 142           | 42        | 265             | 449           |
| 22          | 154           | 12        | 138             | 304           |
| 23          | 103           | 10        | 81              | 194           |
+-------------+---------------+-----------+-----------------+---------------+
24 rows in set (0.03 sec)

-- Query : Average Trip Duration for Completed Trips, by Pickup Point
SELECT
    `Pickup point`,
    AVG(`Trip Duration (minutes)`) AS AverageTripDuration
FROM
    uber_data_cleaned
WHERE
    Status = 'Trip completed'
GROUP BY
    `Pickup point`;
-- Query Output
+--------------+-----------------------+
| Pickup point | AverageTripDuration   |
+--------------+-----------------------+
| Airport      | 52.2384953529264003843|
| City         | 52.5683843085106383916|
+--------------+-----------------------+
2 rows in set (0.03 sec)

-- Query : Percentage of Each Request Status (Overall)  
SELECT
    Status,
    COUNT(*) AS NumberOfRequests,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uber_data_cleaned), 2) AS Percentage
FROM
    uber_data_cleaned
GROUP BY
    Status
ORDER BY
    NumberOfRequests DESC;
-- Query Output
+-------------------+-----------------+------------+
| Status            | NumberOfRequests| Percentage |
+-------------------+-----------------+------------+
| Trip completed    | 2831            | 41.97      |
| No cars available | 2650            | 39.29      |
| Cancelled         | 1264            | 18.74      |
+-------------------+-----------------+------------+
3 rows in set (0.03 sec)

-- Query : Unfulfilled Requests by Day of Week
SELECT
    `Request Day of Week`,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledRequests,
    SUM(CASE WHEN Status = 'No cars available' THEN 1 ELSE 0 END) AS NoCarsAvailableRequests,
    COUNT(*) AS TotalRequests
FROM
    uber_data_cleaned
WHERE
    Status IN ('Cancelled', 'No cars available')
GROUP BY
    `Request Day of Week`
ORDER BY
    TotalRequests DESC;
-- Query Output
+-------------------+-----------------+---------------------+-----------------------+
| Request Day of Week | CancelledRequests | NoCarsAvailableRequests | TotalRequests |
+-------------------+-----------------+---------------------+-----------------------+
| Thursday            | 252               | 571                     | 823           |
| Friday              | 240               | 580                     | 820           |
| Monday              | 262               | 504                     | 766           |
| Wednesday           | 270               | 490                     | 760           |
| Tuesday             | 240               | 505                     | 745           |
+-------------------+-----------------+-----------------------------+---------------+
5 rows in set (0.02 sec)

-- Query : Hourly Percentage of "No Cars Available" vs. "Cancelled" by Pickup Point
SELECT
    `Pickup point`,
    HOUR(`Request timestamp`) AS RequestHour,
    COUNT(*) AS TotalRequestsInHour,
    SUM(CASE WHEN Status = 'Trip completed' THEN 1 ELSE 0 END) AS CompletedTrips,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledTrips,
    SUM(CASE WHEN Status = 'No cars available' THEN 1 ELSE 0 END) AS NoCarsAvailableTrips,
    ROUND(SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Pct_Cancelled,
    ROUND(SUM(CASE WHEN Status = 'No cars available' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Pct_NoCarsAvailable
FROM
    uber_data_cleaned
GROUP BY
    `Pickup point`,
    RequestHour
ORDER BY
    `Pickup point`,
    RequestHour;
-- Query Output
+--------------+-------------+---------------------+----------------+----------------+----------------------+---------------+---------------------+
| Pickup point | RequestHour | TotalRequestsInHour | CompletedTrips | CancelledTrips | NoCarsAvailableTrips | Pct_Cancelled | Pct_NoCarsAvailable |
+--------------+-------------+---------------------+----------------+----------------+----------------------+---------------+---------------------+
| Airport      |           0 |                  53 |             23 |              0 |                   30 |          0.00 |               56.60 |
| Airport      |           1 |                  42 |             13 |              0 |                   29 |          0.00 |               69.05 |
| Airport      |           2 |                  41 |             16 |              0 |                   25 |          0.00 |               60.98 |
| Airport      |           3 |                  45 |             15 |              0 |                   30 |          0.00 |               66.67 |
| Airport      |           4 |                  72 |             36 |              2 |                   34 |          2.78 |               47.22 |
| Airport      |           5 |                  92 |             85 |              4 |                    3 |          4.35 |                3.26 |
| Airport      |           6 |                  89 |             81 |              4 |                    4 |          4.49 |                4.49 |
| Airport      |           7 |                  83 |             75 |              5 |                    3 |          6.02 |                3.61 |
| Airport      |           8 |                  73 |             67 |              2 |                    4 |          2.74 |                5.48 |
| Airport      |           9 |                  89 |             74 |              8 |                    7 |          8.99 |                7.87 |
| Airport      |          10 |                  75 |             53 |              9 |                   13 |         12.00 |               17.33 |
| Airport      |          11 |                  64 |             49 |              5 |                   10 |          7.81 |               15.63 |
| Airport      |          12 |                  87 |             63 |             10 |                   14 |         11.49 |               16.09 |
| Airport      |          13 |                  65 |             35 |              9 |                   21 |         13.85 |               32.31 |
| Airport      |          14 |                  50 |             37 |              6 |                    7 |         12.00 |               14.00 |
| Airport      |          15 |                  76 |             52 |             11 |                   13 |         14.47 |               17.11 |
| Airport      |          16 |                  61 |             38 |             14 |                    9 |         22.95 |               14.75 |
| Airport      |          17 |                 308 |             74 |             19 |                  215 |          6.17 |               69.81 |
| Airport      |          18 |                 405 |             81 |             15 |                  309 |          3.70 |               76.30 |
| Airport      |          19 |                 366 |             83 |             15 |                  268 |          4.10 |               73.22 |
| Airport      |          20 |                 378 |             74 |             29 |                  275 |          7.67 |               72.75 |
| Airport      |          21 |                 343 |             61 |             28 |                  254 |          8.16 |               74.05 |
| Airport      |          22 |                 183 |             80 |              3 |                  100 |          1.64 |               54.64 |
| Airport      |          23 |                  98 |             62 |              0 |                   36 |          0.00 |               36.73 |
| City         |           0 |                  46 |             17 |              3 |                   26 |          6.52 |               56.52 |
| City         |           1 |                  43 |             12 |              4 |                   27 |          9.30 |               62.79 |
| City         |           2 |                  58 |             21 |              5 |                   32 |          8.62 |               55.17 |
| City         |           3 |                  47 |             19 |              2 |                   26 |          4.26 |               55.32 |
| City         |           4 |                 131 |             42 |             49 |                   40 |         37.40 |               30.53 |
| City         |           5 |                 353 |            100 |            172 |                   81 |         48.73 |               22.95 |
| City         |           6 |                 309 |             86 |            141 |                   82 |         45.63 |               26.54 |
| City         |           7 |                 323 |             99 |            164 |                   60 |         50.77 |               18.58 |
| City         |           8 |                 350 |             88 |            176 |                   86 |         50.29 |               24.57 |
| City         |           9 |                 342 |             99 |            167 |                   76 |         48.83 |               22.22 |
| City         |          10 |                 168 |             63 |             53 |                   52 |         31.55 |               30.95 |
| City         |          11 |                 107 |             66 |             10 |                   31 |          9.35 |               28.97 |
| City         |          12 |                  97 |             58 |              9 |                   30 |          9.28 |               30.93 |
| City         |          13 |                  95 |             54 |              9 |                   32 |          9.47 |               33.68 |
| City         |          14 |                  86 |             51 |              5 |                   30 |          5.81 |               34.88 |
| City         |          15 |                  95 |             50 |             10 |                   35 |         10.53 |               36.84 |
| City         |          16 |                  98 |             53 |              8 |                   37 |          8.16 |               37.76 |
| City         |          17 |                 110 |             77 |             16 |                   17 |         14.55 |               15.45 |
| City         |          18 |                 105 |             83 |              9 |                   13 |          8.57 |               12.38 |
| City         |          19 |                 107 |             83 |              9 |                   15 |          8.41 |               14.02 |
| City         |          20 |                 114 |             87 |             12 |                   15 |         10.53 |               13.16 |
| City         |          21 |                 106 |             81 |             14 |                   11 |         13.21 |               10.38 |
| City         |          22 |                 121 |             74 |              9 |                   38 |          7.44 |               31.40 |
| City         |          23 |                  96 |             41 |             10 |                   45 |         10.42 |               46.88 |
+--------------+-------------+---------------------+----------------+----------------+----------------------+---------------+---------------------+
48 rows in set (0.04 sec)

-- Query : Top 5 Drivers by Completed Trips (Excluding Driver ID 0 for Unassigned Trips)
SELECT
    `Driver id`,
    COUNT(*) AS CompletedTrips
FROM
    uber_data_cleaned
WHERE
    Status = 'Trip completed' AND `Driver id` != 0
GROUP BY
    `Driver id`
ORDER BY
    CompletedTrips DESC
LIMIT 5;
-- Query Output
+-----------+---------------+
| Driver id | CompletedTrips|
+-----------+---------------+
| 22        | 16            |
| 233       | 15            |
| 184       | 15            |
| 23        | 14            |
| 16        | 14            |
+-----------+---------------+
5 rows in set (0.01 sec)