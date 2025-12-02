CREATE DATABASE queticousagedb;
USE queticousagedb;

-- Lakes
CREATE TABLE Lakes (
    lake_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    area_km2 FLOAT,
    depth_m FLOAT,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    notes TEXT
);

-- AccessPoints
CREATE TABLE AccessPoints (
    access_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location_lat DECIMAL(9,6),
    location_long DECIMAL(9,6),
    type ENUM('road','canoe','portage') NOT NULL
);

-- Portages (land connections between lakes)
CREATE TABLE Portages (
    portage_id INT AUTO_INCREMENT PRIMARY KEY,
    from_lake_id INT NOT NULL,
    to_lake_id INT NOT NULL,
    distance_km FLOAT,
    difficulty ENUM('easy','moderate','hard'),
    maintenance_status ENUM('good','needs repair','closed') DEFAULT 'good',
    FOREIGN KEY (from_lake_id) REFERENCES Lakes(lake_id),
    FOREIGN KEY (to_lake_id) REFERENCES Lakes(lake_id)
);

-- TouristTraffic (lake-level usage statistics)
CREATE TABLE TouristTraffic (
    traffic_id INT AUTO_INCREMENT PRIMARY KEY,
    lake_id INT NOT NULL,
    season ENUM('spring','summer','fall','winter') NOT NULL,
    year INT NOT NULL,
    visitors_count INT NOT NULL,
    FOREIGN KEY (lake_id) REFERENCES Lakes(lake_id)
);

-- Users
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,   -- store hashed passwords
    role ENUM('ranger','outfitter') NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Permits
CREATE TABLE Permits (
    permit_id INT AUTO_INCREMENT PRIMARY KEY,
    access_id INT NOT NULL,
    issue_date DATE NOT NULL,
    group_size INT NOT NULL,
    duration_days INT NOT NULL,
    FOREIGN KEY (access_id) REFERENCES AccessPoints(access_id),
    issued_by INT,
	FOREIGN KEY (issued_by) REFERENCES Users(user_id)
);