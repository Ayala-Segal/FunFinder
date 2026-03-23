-- 1. Categories Table
CREATE TABLE categories (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    icon_identifier VARCHAR(50) -- e.g., 'MapPin', 'Wine', 'Activity'
);

-- 2. Users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Attractions Table
CREATE TABLE attractions (
    attraction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES categories(category_id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    short_description TEXT,
    full_description TEXT,
    location VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('Easy', 'Medium', 'Hard')),
    duration VARCHAR(50), -- e.g., '4 Hours', 'Full Day'
    target_audience VARCHAR(100), -- e.g., 'Adults', 'Families with kids'
    avg_rating DECIMAL(3, 2) DEFAULT 0,
    review_count INTEGER DEFAULT 0,
    main_image_url TEXT
);

-- 4. Gallery Images Table (One-to-Many with Attractions)
CREATE TABLE gallery_images (
    image_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attraction_id UUID REFERENCES attractions(attraction_id) ON DELETE CASCADE,
    image_url TEXT NOT NULL
);

-- 5. Bookings Table
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    attraction_id UUID REFERENCES attractions(attraction_id) ON DELETE CASCADE,
    booking_date DATE NOT NULL,
    ticket_count INTEGER NOT NULL CHECK (ticket_count > 0),
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmed' CHECK (status IN ('Confirmed', 'Cancelled')),
    contact_name VARCHAR(100), -- Captured at checkout
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Reviews Table
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    attraction_id UUID REFERENCES attractions(attraction_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_attractions_category ON attractions(category_id);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_reviews_attraction ON reviews(attraction_id);