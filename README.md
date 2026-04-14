# FunFinder
# 🎯 FunFinder – Attractions Management System

## Table of Contents

* [Phase 1: Design and Build the Database](#phase-1-design-and-build-the-database)

  * [Introduction](#introduction)
  * [ERD (Entity-Relationship Diagram)](#erd-entity-relationship-diagram)
  * [DSD (Data Structure Diagram)](#dsd-data-structure-diagram)
  * [SQL Scripts](#sql-scripts)
  * [Data](#data)
  * [Backup & Environment](#backup--environment)
* [Phase 2: Integration](#phase-2-integration)

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

📂 [View DataImportFiles](https://github.com/Ayala-Segal/FunFinder/tree/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles)

Includes:

* users.csv
* bookings.csv
* attractions.csv
* categories.csv
* reviews.csv
* gallery_images.csv
* booking_details.csv

---

#### 🔹 Mockaroo (SQL Data)

📂 https://github.com/Ayala-Segal/FunFinder/tree/main/MockarooFiles

Generated SQL files for all main tables.

---

#### 🔹 Python Data Generator

📜 https://github.com/Ayala-Segal/FunFinder/blob/main/Programming/generate_data.py

Used for generating large-scale and dynamic datasets.

---

### Backup

-   backups files are kept with the date and hour of the backup:  
????
---

