# FunFinder
# 🎯 FunFinder – Attractions Management System

## Table of Contents

* [Phase 1: Design and Build the Database](#phase-1-design-and-build-the-database)

  * [Introduction](#introduction)
  * [ERD (Entity-Relationship Diagram)](#erd-entity-relationship-diagram)
  * [DSD (Data Structure Diagram)](#dsd-data-structure-diagram)
  * [SQL Scripts](#sql-scripts)
  * [Data](#data)
  * [Backup](#backup)
---

## Phase 1: Design and Build the Database

### Introduction

The **FunFinder system** is designed to manage attractions, bookings, and user interactions in a structured and efficient way.
It provides a complete database solution for handling attractions, reservations, reviews, and related content.

#### Purpose of the Database

* Managing attractions with categories, pricing, and descriptions
* Handling bookings and ticket management
* Tracking users and their activity
* Managing reviews and ratings
* Storing images for each attraction

#### Potential Use Cases

* Users can browse attractions and book tickets
* Administrators manage attractions and categories
* The system analyzes popularity and ratings
* Businesses can present and manage their attractions

---

## 🖼️ System Overview (Application View)

This section presents the main screens of the system and demonstrates how users interact with the application in practice.

### 🏠 Home Page
The main landing page that provides general navigation and overview of attractions.
![Home 1](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/home1.png)
![Home 2](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/home2.png)
![Home 3](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/home3.png)

---

### 🎟️ Attractions Page
Displays all available attractions with details and filtering options.
![Attractions](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/attractions.png)

---

### 🔐 Login Page
User authentication screen for system access.
![Login](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/connection.png)

---

### 🛒 Orders Page
Shows user bookings and order history.
![Orders](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/order.png)

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

📜 https://github.com/Ayala-Segal/FunFinder/blob/main/Programming/generate_data.py

Used for generating large-scale and dynamic datasets.

---

### Backup

-   backups files are kept with the date and hour of the backup:  

---

