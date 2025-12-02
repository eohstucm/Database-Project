-- Lakes
INSERT INTO Lakes (name, area_km2, depth_m, latitude, longitude, notes) VALUES
('Quetico Lake', 23.5, 45.0, 48.300000, -91.200000, 'Large central lake'),
('Pickerel Lake', 15.2, 38.0, 48.350000, -91.150000, 'Popular fishing spot'),
('Batchewaung Lake', 12.8, 30.0, 48.310000, -91.180000, 'Known for canoe routes'),
('Sturgeon Lake', 20.1, 50.0, 48.280000, -91.250000, 'Deep lake with campsites');

-- AccessPoints
INSERT INTO AccessPoints (name, location_lat, location_long, type) VALUES
('Dawson Trail Campground', 48.350000, -91.150000, 'road'),
('Pickerel Lake Canoe Launch', 48.355000, -91.145000, 'canoe'),
('Batchewaung Portage Trailhead', 48.310000, -91.180000, 'portage');

-- Portages
INSERT INTO Portages (from_lake_id, to_lake_id, distance_km, difficulty, maintenance_status) VALUES
(1, 2, 1.2, 'easy', 'good'),
(2, 3, 0.8, 'moderate', 'needs repair'),
(3, 4, 2.5, 'hard', 'closed');

-- Users
INSERT INTO Users (username, password_hash, role, email) VALUES
('ranger_john', 'hashed_pw_123', 'ranger', 'john.ranger@example.com'),
('ranger_sara', 'hashed_pw_456', 'ranger', 'sara.ranger@example.com'),
('outfitter_mike', 'hashed_pw_789', 'outfitter', 'mike.outfitter@example.com');

-- Permits
INSERT INTO Permits (access_id, issue_date, group_size, duration_days, issued_by) VALUES
(1, '2025-06-15', 4, 5, 3),
(2, '2025-07-01', 2, 3, 3),
(3, '2025-08-10', 6, 7, 3);

-- TouristTraffic
INSERT INTO TouristTraffic (lake_id, season, year, visitors_count) VALUES
(1, 'spring', 2024, 4),
(1, 'summer', 2024, 6),
(1, 'summer', 2024, 2),
(1, 'fall', 2024, 5),
(1, 'winter', 2024, 3),
(2, 'spring', 2024, 3),
(2, 'summer', 2024, 8),
(2, 'fall', 2024, 4),
(2, 'winter', 2024, 2),
(2, 'summer', 2025, 5),
(3, 'spring', 2025, 6),
(3, 'summer', 2025, 4),
(3, 'summer', 2025, 7),
(3, 'fall', 2025, 3),
(3, 'winter', 2025, 2),
(4, 'spring', 2025, 5),
(4, 'summer', 2025, 9),
(4, 'fall', 2025, 4),
(4, 'winter', 2025, 6),
(4, 'summer', 2024, 7);

