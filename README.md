# 🎯 FunFinder – Attractions Management System

## Table of Contents

- [Phase 1: Design and Build the Database](#phase-1-design-and-build-the-database)
  - Introduction
  - Purpose of the Database
  - Potential Use Cases
  - System Overview
  - ERD (Entity-Relationship Diagram)
  - DSD (Data Structure Diagram)
  - SQL Scripts
  - Data
  - Backup

---

## Phase 1: Design and Build the Database

### Introduction

The **FunFinder system** is designed to manage attractions, bookings, and user interactions in a structured and efficient way.  
It provides a complete database solution for handling attractions, reservations, reviews, and related content.

### Purpose of the Database

- Managing attractions with categories, pricing, and descriptions  
- Handling bookings and ticket management  
- Tracking users and their activity  
- Managing reviews and ratings  
- Storing images for each attraction  

### Potential Use Cases

- Users can browse attractions and book tickets  
- Administrators manage attractions and categories  
- The system analyzes popularity and ratings  
- Businesses can present and manage their attractions  

---

## 🚀 AI Studio Preview

📌 View the system prototype and AI design:  
https://ai.studio/apps/5c3de8b2-1857-4c0e-964f-efd5e41495a2

---

## 🖼️ System Overview (Application View)

This section presents the main screens of the system and demonstrates how users interact with the application.

### 🏠 Home Page

The main landing page provides navigation and a general overview of available attractions.

![Home 1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home1.png)
![Home 2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home2.png)
![Home 3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home3.png)

---

### 🎟️ Attractions Page

Displays all available attractions with filtering, search options, and detailed information.

![Attractions](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/attractions.png)

---

### 🔐 Login Page

User authentication screen for secure system access.

![Login](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/connection.png)

---

### 🛒 Orders Page

Displays user booking history and order management.

![Orders](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/order.png)
---

### ERD (Entity-Relationship Diagram)

![ERD Diagram](https://github.com/Ayala-Segal/FunFinder/blob/main/ERDAndDSTFiles/ERD.png)

---

### DSD (Data Structure Diagram)

![DSD Diagram](https://github.com/Ayala-Segal/FunFinder/blob/main/ERDAndDSTFiles/DSD.png)

---

### SQL Scripts

* 📜 [Create Tables](https://github.com/Ayala-Segal/FunFinder/blob/main/script/create_tables.sql)
* 📜 [Insert Data](https://github.com/Ayala-Segal/FunFinder/blob/main/script/insert.sql)
* 📜 [Drop Tables](https://github.com/Ayala-Segal/FunFinder/blob/main/script/drop_tables.sql)
* 📜 [Select All Data](https://github.com/Ayala-Segal/FunFinder/blob/main/script/select_all.sql)

---

### Data

#### 🔹 CSV Files (Data Import)

📂 DataImportFiles

* 📄 [users.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/users.csv)
* 📄 [bookings.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/bookings.csv)
* 📄 [attractions.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/attractions.csv)
* 📄 [categories.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/categories.csv)
* 📄 [reviews.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/reviews.csv)
* 📄 [gallery_images.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/gallery_images.csv)
* 📄 [booking_details.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/booking_details.csv)

---

#### 🔹 Mockaroo (SQL Data)

📂 MockarooFiles

* 📄 [users.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/users.sql)
* 📄 [bookings.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/bookings.sql)
* 📄 [attractions.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/attractions.sql)
* 📄 [categories.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/categories.sql)
* 📄 [reviews.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/reviews.sql)
* 📄 [gallery_images.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/gallery_images.sql)
* 📄 [booking_details.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/booking_details.sql)

---

#### 🔹 Python Data Generator

📜[generate_data.py](https://github.com/Ayala-Segal/FunFinder/blob/main/Programming/generate_data.py)

Used for generating large-scale and dynamic datasets.

---

### Backup

-   backups files are kept with the date and hour of the backup:  
📂 [View Backups Folder](https://github.com/Ayala-Segal/FunFinder/tree/main/backup)
