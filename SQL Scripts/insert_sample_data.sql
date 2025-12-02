-- Lakes
INSERT INTO Lakes (name, area_km2, depth_m, latitude, longitude, notes)
VALUES
('Lake Agnes', 5.2, 24.5, 48.123456, -91.234567, 'Popular canoe route lake'),
('Boundary Lake', 3.8, 18.0, 48.223456, -91.334567, 'Forms part of park boundary'),
('Pickerel Lake', 10.5, 30.2, 48.323456, -91.434567, 'Large entry lake'),
('Cirrus Lake', 7.1, 22.0, 48.423456, -91.534567, 'Known for fishing'),
('Quetico Lake', 12.0, 35.0, 48.523456, -91.634567, 'Central lake in park');

-- AccessPoints
INSERT INTO AccessPoints (name, location_lat, location_long, type)
VALUES
('Dawson Trail', 48.700000, -91.900000, 'road'),
('French Lake', 48.650000, -91.850000, 'canoe'),
('Prairie Portage', 48.500000, -91.750000, 'portage');

-- Routes
INSERT INTO Routes (from_lake_id, to_lake_id, distance_km, difficulty)
VALUES
(1, 2, 4.5, 'moderate'),
(2, 3, 6.0, 'easy'),
(3, 4, 8.2, 'hard'),
(4, 5, 5.0, 'moderate');

-- Portages
INSERT INTO Portages (from_lake_id, to_lake_id, distance_km, difficulty, maintenance_status)
VALUES
(1, 2, 1.2, 'easy', 'good'),
(2, 3, 0.8, 'moderate', 'needs repair'),
(3, 4, 1.5, 'hard', 'good'),
(4, 5, 2.0, 'moderate', 'closed');

-- TouristTraffic
INSERT INTO TouristTraffic (lake_id, date, visitors_count, season, activity_type)
VALUES
(1, '2025-07-15', 120, 'summer', 'canoeing'),
(2, '2025-07-15', 80, 'summer', 'fishing'),
(3, '2025-08-01', 150, 'summer', 'camping'),
(4, '2025-09-10', 60, 'fall', 'canoeing'),
(5, '2025-06-20', 90, 'spring', 'fishing');

-- PortageTraffic
INSERT INTO PortageTraffic (portage_id, date, users_count, season, activity_type)
VALUES
(1, '2025-07-15', 40, 'summer', 'canoeing'),
(2, '2025-07-15', 25, 'summer', 'canoeing'),
(3, '2025-08-01', 30, 'summer', 'hiking'),
(4, '2025-09-10', 10, 'fall', 'canoeing');

-- Permits
INSERT INTO Permits (access_id, issue_date, group_size, duration_days, issued_by)
VALUES
(1, '2025-07-14', 4, 5, 3),
(2, '2025-07-15', 2, 3, 4),
(3, '2025-08-01', 6, 7, 5),
(1, '2025-09-10', 3, 4, 3),
(2, '2025-06-20', 5, 6, 4);


-- Users
INSERT INTO Users (username, password_hash, role, email)
VALUES
('ranger_john', 'hash123abc', 'ranger', 'john.ranger@quetico.org'),
('ranger_sarah', 'hash456def', 'ranger', 'sarah.ranger@quetico.org'),
('outfitter_northwoods', 'hash789ghi', 'outfitter', 'info@northwoodsoutfitters.com'),
('outfitter_boundary', 'hash321jkl', 'outfitter', 'contact@boundarycanoe.com'),
('outfitter_pickerel', 'hash654mno', 'outfitter', 'trips@pickereloutfitters.com');

