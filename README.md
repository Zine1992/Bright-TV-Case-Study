# Bright-TV-Case-Study
This is a project about analysing the viewership stat of Bright TV
CREATE OR REPLACE TEMPORARY TABLE user_profiles AS( SELECT
        UserID,
        CASE
            WHEN TRIM(Province) = '' OR Province IS NULL THEN 'Uncategorized'
            WHEN Province = 'None' THEN 'Uncategorized'
            ELSE Province
        END AS Region,

        Age,

        CASE
            WHEN Age = 0 THEN 'Infants'
            WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
            WHEN Age BETWEEN 13 AND 19 THEN 'Teenager'
            WHEN Age BETWEEN 20 AND 35 THEN 'Youth'
            WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
            WHEN Age BETWEEN 51 AND 65 THEN 'Elder'
            WHEN Age > 65 THEN 'Pensioner'
            ELSE 'Unknown'
        END AS age_groups,

        CASE
            WHEN email IS NOT NULL
                 AND TRIM(email) <> ''
                 AND LOWER(email) <> 'none'
            THEN 1 ELSE 0
        END AS email_flag,

        CASE
            WHEN `Social Media Handle` IS NOT NULL
                 AND TRIM(`Social Media Handle`) <> ''
                 AND LOWER(`Social Media Handle`) <> 'none'
            THEN 1 ELSE 0
        END AS sm_flag,

        CASE
            WHEN LOWER(TRIM(Race)) = 'other' THEN 'None'
            WHEN TRIM(Race) = '' OR Race IS NULL THEN 'None'
            ELSE Race
        END AS Race,

        CASE
            WHEN TRIM(gender) = '' OR gender IS NULL THEN 'None'
            ELSE gender
        END AS Gender

    FROM brighttv.data.user_profile
);

CREATE OR REPLACE TEMPORARY TABLE viewership AS (
    SELECT
        COALESCE(UserID0, UserID4) AS userid,

        DATE_FORMAT(RecordDate2, 'yyyyMM') AS month_id,
        TO_DATE(RecordDate2) AS watch_date,
        DATE_FORMAT(RecordDate2, 'dd') AS day_of_month,
        DAYNAME(RecordDate2) AS day_name,

        CASE
            WHEN DAYNAME(RecordDate2) IN ('Sat', 'Sun')
            THEN 'weekend'
            ELSE 'weekday'
        END AS day_classification,

        MONTHNAME(RecordDate2) AS month_name,

        CASE
            WHEN Channel2 IN ('SawSee', 'Sawsee') THEN 'SawSee'
            WHEN Channel2 IN (
                'SuperSport Live Events',
                'Live on SuperSport',
                'Supersport Live Events',
                'DStv Events 1'
            ) THEN 'Live Events'
            ELSE Channel2
        END AS Tv_channel,

        DATE_FORMAT(RecordDate2, 'HH:mm:ss') AS watch_time,

        CASE
            WHEN DATE_FORMAT(RecordDate2, 'HH:mm:ss')
                 BETWEEN '00:00:00' AND '05:59:59'
            THEN '01. Midnight'

            WHEN DATE_FORMAT(RecordDate2, 'HH:mm:ss')
                 BETWEEN '06:00:00' AND '11:59:59'
            THEN '02. Morning'

            WHEN DATE_FORMAT(RecordDate2, 'HH:mm:ss')
                 BETWEEN '12:00:00' AND '16:59:59'
            THEN '03. Afternoon'

            ELSE '04. Evening'
        END AS time_of_day,

        DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration,

        CASE
            WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss')
                 BETWEEN '00:05:00' AND '00:30:00'
            THEN '01. Low Usage: <30 min'

            WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss')
                 BETWEEN '00:30:01' AND '00:59:59'
            THEN '02. Med Usage: <60 min'

            WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss') > '00:59:59'
            THEN '03. High Usage: >60 min'

            ELSE '04. No Usage'
        END AS screen_time_bucket,

        HOUR(RecordDate2) AS hour_of_day

    FROM brighttv.data.viewerships
);

SELECT
    COALESCE(A.userid, B.UserID) AS sub_id,
    A.month_id,
    A.watch_date,
    A.day_of_month,
    A.day_name,
    A.day_classification,
    A.month_name,
    A.Tv_channel,
    A.watch_time,
    A.time_of_day,
    A.hour_of_day,
    A.screen_time_bucket,
    A.duration,
    B.Region,
    B.age_groups,
    B.email_flag,
    B.sm_flag,
    B.Race,
    B.Gender
FROM viewership AS A
LEFT JOIN user_profiles AS B
    ON A.userid = B.UserID;

SELECT *
FROM brighttv.data.viewerships
LIMIT 10;

-- Check NULL user IDs
SELECT *
FROM brighttv.data.viewerships
WHERE UserID0 IS NULL
   OR UserID4 IS NULL;

-- Check mismatched user IDs
SELECT *
FROM brighttv.data.viewerships
WHERE UserID0 <> UserID4;

-- Check duplicate records
SELECT
    UserID0,
    RecordDate2,
    COUNT(*) AS duplicate_count
FROM brighttv.data.viewerships
GROUP BY UserID0, RecordDate2
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- View watch history for a specific user
SELECT
    COALESCE(UserID0, UserID4) AS UserID,
    TO_DATE(RecordDate2) AS watch_date,
    DATE_FORMAT(RecordDate2, 'HH:mm:ss') AS watch_time,
    DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration,
    Channel2
FROM brighttv.data.viewerships
WHERE COALESCE(UserID0, UserID4) = 810044;
