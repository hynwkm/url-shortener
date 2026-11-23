
-- Check current database
SELECT DATABASE() AS current_database;

-- Check MariaDB version
SELECT VERSION() AS mariadb_version;

-- Check current users
SELECT USER() AS connected_user;

-- Check available tables
SHOW TABLES;

-- Test table creation and insertion
CREATE TABLE IF NOT EXISTS docker_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(100) NOT NULL
);

INSERT INTO docker_test (message)
VALUES ('MariaDB initialization successful');

SELECT * FROM docker_test;
