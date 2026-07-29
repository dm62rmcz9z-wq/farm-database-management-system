DROP DATABASE IF EXISTS sustainable_farming;
CREATE DATABASE sustainable_farming;
USE sustainable_farming;

/*
# farm_id as primary key for farms table, farm_location with max length of 100 characters, 
# water_source with max length of 50 characters
*/
CREATE TABLE farms (
    farm_id INT PRIMARY KEY,
    farm_location VARCHAR(100) NOT NULL,
    water_source VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

/*
# crop_id as primary key for crops table, farm_id as foreign key referencing farms table,
# crop_name with max length of 50 characters, planting_date and harvest_date as DATE type
# delete cascade for farm_id foreign key
*/
CREATE TABLE crops (
    crop_id INT PRIMARY KEY,
    farm_id INT NOT NULL,
    crop_name VARCHAR(50) NOT NULL,
    planting_date DATE NOT NULL,
    harvest_date DATE NOT NULL,
    crop_yield INT NOT NULL,
    labour_hours INT NOT NULL,
    UNIQUE KEY uq_crop_farm (crop_id, farm_id),
    CONSTRAINT fk_crops_farm
        FOREIGN KEY (farm_id) REFERENCES farms(farm_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

/*
# soil_id as primary key for soil_health_metrics table, farm_id as foreign key referencing farms table,
# ph_level as DECIMAL with precision 3 and scale 1, nitrogen_level, phosphorus_level, and potassium_level as INT type
# delete cascade for farm_id foreign key
*/
CREATE TABLE soil_health_metrics (
    soil_id INT PRIMARY KEY,
    farm_id INT NOT NULL,
    ph_level DECIMAL(3,1) NOT NULL,
    nitrogen_level INT NOT NULL,
    phosphorus_level INT NOT NULL,
    potassium_level INT NOT NULL,
    CONSTRAINT fk_soil_farm
        FOREIGN KEY (farm_id) REFERENCES farms(farm_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

# resource_id as primary key for resource_types table, resource_type with max length of 50 characters
CREATE TABLE resource_types (
    resource_id INT PRIMARY KEY,
    resource_type VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

/*
# sustainability_initiative_id as primary key for sustainability_initiatives table, farm_id as foreign key referencing farms table,
# initiative_description with max length of 100 characters, date_initiated as DATE type,
# expected_impact with max length of 100 characters, environmental_impact_score as TINYINT type with a check constraint to ensure values are between 1 and 5
# delete cascade for farm_id foreign key
*/
CREATE TABLE sustainability_initiatives (
    sustainability_initiative_id INT PRIMARY KEY,
    farm_id INT NOT NULL,
    initiative_description VARCHAR(100) NOT NULL,
    date_initiated DATE NOT NULL,
    expected_impact VARCHAR(100) NOT NULL,
    environmental_impact_score TINYINT NOT NULL,
    CONSTRAINT chk_environmental_score CHECK (environmental_impact_score BETWEEN 1 AND 5),
    CONSTRAINT fk_initiative_farm
        FOREIGN KEY (farm_id) REFERENCES farms(farm_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

/*
# resource_usage table with composite primary key (farm_id, crop_id, resource_id, date_of_application),
# farm_id as foreign key referencing farms table, crop_id as foreign key referencing crops table,
# resource_id as foreign key referencing resource_types table, resource_quantity as DECIMAL with precision 12 and scale 2, date_of_application as DATE type
# delete cascade for farm_id foreign key, restrict delete for crop_id and resource_id foreign keys
*/
CREATE TABLE resource_usage (
    farm_id INT NOT NULL,
    crop_id INT NOT NULL,
    resource_id INT NOT NULL,
    resource_quantity DECIMAL(12,2) NOT NULL,
    date_of_application DATE NOT NULL,
    PRIMARY KEY (farm_id, crop_id, resource_id, date_of_application),
    CONSTRAINT fk_usage_farm
        FOREIGN KEY (farm_id) REFERENCES farms(farm_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_usage_crop_farm
        FOREIGN KEY (crop_id, farm_id) REFERENCES crops(crop_id, farm_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_usage_resource
        FOREIGN KEY (resource_id) REFERENCES resource_types(resource_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO farms (farm_id, farm_location, water_source) VALUES
    (1, 'South Farm, Kent', 'River'),
    (2, 'Green Acres, Essex', 'Borehole'),
    (3, 'Sunny Fields, Hampshire', 'Rainwater'),
    (4, 'Hilltop Farm, Yorkshire', 'Well'),
    (5, 'Riverbend Farm, Cornwall', 'River');

INSERT INTO crops (crop_id, farm_id, crop_name, planting_date, harvest_date, crop_yield, labour_hours) VALUES
    (101, 1, 'Wheat', '2023-03-15', '2023-08-15', 3000, 150),
    (102, 1, 'Barley', '2023-03-16', '2023-08-20', 2800, 120),
    (201, 2, 'Corn', '2023-04-10', '2023-09-15', 1500, 200),
    (202, 2, 'Soybeans', '2023-04-11', '2023-09-20', 1200, 180),
    (301, 3, 'Potatoes', '2023-03-20', '2023-07-15', 2000, 160),
    (302, 3, 'Carrots', '2023-03-21', '2023-07-20', 2200, 170),
    (401, 4, 'Apples', '2023-04-05', '2023-09-10', 1800, 140),
    (402, 4, 'Pears', '2023-04-06', '2023-09-15', 1600, 130),
    (501, 5, 'Tomatoes', '2023-03-25', '2023-08-10', 2500, 190),
    (502, 5, 'Lettuce', '2023-03-26', '2023-08-15', 2400, 175);

INSERT INTO soil_health_metrics (soil_id, farm_id, ph_level, nitrogen_level, phosphorus_level, potassium_level) VALUES
    (1, 1, 6.5, 50, 20, 180),
    (2, 2, 6.8, 40, 25, 160),
    (3, 3, 6.2, 30, 15, 150),
    (4, 4, 6.4, 45, 22, 175),
    (5, 5, 6.7, 55, 28, 200);

INSERT INTO resource_types (resource_id, resource_type) VALUES
    (1, 'Water'),
    (2, 'Fertilizer'),
    (3, 'Energy');

INSERT INTO sustainability_initiatives (
    sustainability_initiative_id,
    farm_id,
    initiative_description,
    date_initiated,
    expected_impact,
    environmental_impact_score
) VALUES
    (1, 1, 'Organic Farming', '2023-01-01', 'Increase in yield', 4),
    (2, 2, 'Crop Rotation', '2023-02-15', 'Improved soil quality', 3),
    (3, 3, 'Water Conservation', '2023-03-01', 'Reduced water usage', 5),
    (4, 4, 'Soil Health Improvement', '2023-01-20', 'Enhanced nutrient retention', 2),
    (5, 5, 'Pesticide Reduction', '2023-02-10', 'Less chemical runoff', 4);

INSERT INTO resource_usage (
    farm_id,
    crop_id,
    resource_id,
    resource_quantity,
    date_of_application
) VALUES
    (1, 101, 1, 1000, '2023-03-10'),
    (1, 101, 3, 360000, '2023-05-30'),
    (1, 102, 2, 200, '2023-03-12'),
    (1, 102, 3, 280000, '2023-06-02'),
    (2, 201, 1, 800, '2023-04-05'),
    (2, 201, 3, 180000, '2023-09-24'),
    (2, 202, 2, 150, '2023-04-06'),
    (2, 202, 3, 144000, '2023-10-12'),
    (3, 301, 1, 1200, '2023-03-18'),
    (3, 301, 3, 240000, '2023-05-17'),
    (3, 302, 2, 300, '2023-03-19'),
    (3, 302, 3, 264000, '2023-05-20'),
    (4, 401, 1, 900, '2023-04-02'),
    (4, 401, 3, 216000, '2023-07-22'),
    (4, 402, 2, 250, '2023-04-03'),
    (4, 402, 3, 192000, '2023-07-25'),
    (5, 501, 3, 300000, '2023-07-01'),
    (5, 501, 1, 1100, '2023-03-22'),
    (5, 502, 3, 288000, '2023-06-05'),
    (5, 502, 2, 180, '2023-03-24');