# Farm Database Management System

A normalised MySQL farm database with SQL implementation and relational database design.

## Project Overview

This project designs and implements a relational database for sustainable farming data.

The database stores information about:

- Farms
- Crops
- Soil health metrics
- Resource usage
- Resource types
- Sustainability initiatives

The original CSV dataset was normalised before the database was implemented in MySQL.

## Database Design

The database contains the following main entities:

- `Farm`
- `Crop`
- `SoilHealthMetrics`
- `ResourceUsage`
- `ResourceType`
- `SustainabilityInitiatives`

Primary keys and foreign keys are used to connect the tables and maintain referential integrity.

## Normalisation

The original dataset was normalised through:

- First Normal Form
- Second Normal Form
- Third Normal Form
- Boyce-Codd Normal Form

The normalised structure reduces:

- Data duplication
- Partial dependencies
- Transitive dependencies
- Insertion anomalies
- Update anomalies
- Deletion anomalies

## Repository Structure

```text
farm-database-management-system/
├── README.md
├── farm_database.sql
└── farm_data.csv
