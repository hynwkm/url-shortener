
-- Check current database
SELECT DATABASE() AS current_database;

-- Check MariaDB version
SELECT VERSION() AS mariadb_version;

-- Check current users
SELECT USER() AS connected_user;

-- Check available tables
SHOW TABLES;

-- Test table creation and insertion

-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS shortener
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 선택
USE shortener;

-- URL 테이블 생성
CREATE TABLE IF NOT EXISTS urls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    short_code VARCHAR(16) NOT NULL UNIQUE,
    original_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);