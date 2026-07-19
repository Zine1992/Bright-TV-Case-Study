-- Databricks notebook source
FROM workspace.default.bright_tv_user_profiles
LIMIT 10;-Gender Checks
---------------------------------------------------------
SELECT DISTINCT gender
FROM workspace.default.bright_tv_user_profiles;
SELECT COUNT(*)
FROM workspace.default.bright_tv_user_profiles
WHERE gender=' ';
SELECT 
 COUNT(DISTINCT userid) AS subs, 
  CASE
   WHEN gender =' ' THEN 'None'
    ELSE gender
     END AS Gender
     FROM workspace.default.bright_tv_user_profiles
     GROUP BY Gender;
     ---------------------------------------------------------
     --Race Checks
     ---------------------------------------------------------
     SELECT COUNT(*) AS num_rows
     FROM workspace.default.bright_tv_user_profiles
     WHERE Race IS NULL;
     SELECT DISTINCT Race
     FROM workspace.default.bright_tv_user_profiles;
     SELECT DISTINCT
      -Gender Checks
---------------------------------------------------------
SELECT DISTINCT gender
FROM workspace.default.bright_tv_user_profiles;
SELECT COUNT(*)
FROM workspace.default.bright_tv_user_profiles
WHERE gender=' ';
SELECT 
 COUNT(DISTINCT userid) AS subs, 
 CASE
 WHEN gender =' ' THEN 'None'
 ELSE gender
 END AS Gender
FROM workspace.default.bright_tv_user_profiles
GROUP BY Gender;
---------------------------------------------------------
--Race Checks
---------------------------------------------------------
SELECT COUNT(*) AS num_rows
FROM workspace.default.bright_tv_user_profiles
WHERE Race IS NULL;
5 DISTINCT Race
FROM workspace.default.bright_tv_user_profiles;
SELECT DISTINCT
 CASE
-- checking for duplicates in my data
SELECT UserID, 
 COUNT(*) AS duplicate_count
 FROM workspace.default.bright_tv_user_profiles
 GROUP BY UserID
 HAVING COUNT(*) > 1;
 -- I am checking the size pf the data
 SELECT COUNT(*) AS number_of_rows,
  COUNT(DISTINCT UserID) AS number_subs
  FROM workspace.default.bright_tv_user_profiles;
  -- Are the any rows where useRID is NULL 
  SELECT COUNT(*) AS cnt
  FROM workspace.default.bright_tv_user_profiles
  WHERE UserID IS NULL;
  SELECT DISTINCT UserID
  FROM workspace.default.bright_tv_user_profiles;
  --------------------------

