CREATE SCHEMA public;
SET search_path TO public;

CREATE TABLE USERS
(
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  avatar_url VARCHAR(255),
  created_at TIMESTAMP NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE BOOKINGS
(
  booking_id INT NOT NULL,
  booking_date DATE NOT NULL,
  ticket_count INT NOT NULL,
  status VARCHAR(50) NOT NULL,
  contact_name VARCHAR(100) NOT NULL,
  contact_email VARCHAR(150) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  contact_phone VARCHAR(20),
  user_id INT NOT NULL,
  PRIMARY KEY (booking_id),
  FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

CREATE TABLE CATEGORIES
(
  category_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  icon_identifier VARCHAR(100),
  PRIMARY KEY (category_id)
);

CREATE TABLE ATTRACTIONS
(
  attraction_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  short_description VARCHAR(255) NOT NULL,
  full_description TEXT,
  location VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  difficulty_level FLOAT NOT NULL,
  duration INT NOT NULL,
  target_audience VARCHAR(100) NOT NULL,
  avg_rating DECIMAL(3,2),
  review_count INT DEFAULT 0,
  main_image_url VARCHAR(255),
  category_id INT NOT NULL,
  PRIMARY KEY (attraction_id),
  FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id)
);

CREATE TABLE GALLERY_IMAGES
(
  image_url VARCHAR(255) NOT NULL,
  image_id INT NOT NULL,
  attraction_id INT NOT NULL,
  PRIMARY KEY (image_id),
  FOREIGN KEY (attraction_id) REFERENCES ATTRACTIONS(attraction_id)
);

CREATE TABLE REVIEWS
(
  review_id INT NOT NULL,
  comment VARCHAR(250),
  created_at TIMESTAMP NOT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  user_id INT NOT NULL,
  attraction_id INT NOT NULL,
  PRIMARY KEY (review_id),
  FOREIGN KEY (user_id) REFERENCES USERS(user_id),
  FOREIGN KEY (attraction_id) REFERENCES ATTRACTIONS(attraction_id)
);

CREATE TABLE BOOKING_DETAILS
(
  booking_id INT NOT NULL,
  attraction_id INT NOT NULL,
  ticket_count INT NOT NULL,
  PRIMARY KEY (booking_id, attraction_id),
  FOREIGN KEY (booking_id) REFERENCES BOOKINGS(booking_id),
  FOREIGN KEY (attraction_id) REFERENCES ATTRACTIONS(attraction_id)
);