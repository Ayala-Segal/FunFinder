-- Insert Categories
INSERT INTO categories (name, icon_identifier) VALUES 
('Family', 'Users'),
('Adventure', 'Mountain'),
('Adults', 'Wine'),
('Children', 'Baby');

-- Insert a Sample Attraction
INSERT INTO attractions (name, category_id, price, difficulty_level, location, duration)
VALUES (
    'Grand Canyon Helicopter Tour', 
    (SELECT category_id FROM categories WHERE name = 'Adventure'), 
    299.00, 
    'Medium', 
    'Las Vegas, NV', 
    '4 Hours'
);

commit;