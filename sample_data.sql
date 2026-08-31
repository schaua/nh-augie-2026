-- Create a new database 

DROP DATABASE IF EXISTS sports_equipment;
CREATE DATABASE sports_equipment;

-- Add the tables 

DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS sport;

CREATE TABLE sport (
    sport_id   integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sport_name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE equipment (
    equipment_id   integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    equipment_name varchar(100) NOT NULL,
    sport_id       integer NULL
    -- Deliberately no foreign key so orphaned equipment can illustrate gaps.
);
-- and populate with sample data.

INSERT INTO sport (sport_name) VALUES
    ('Archery'),
    ('Basketball'),
    ('Cycling'),
    ('Soccer'),
    ('Swimming'),
    ('Tennis'),
    ('Whitewater Rafting');

INSERT INTO equipment (equipment_name, sport_id) VALUES
    ('Basketball', 2),
    ('Basketball hoop', 2),
    ('Bicycle helmet', 3),
    ('Broom', 10),
    ('Goal net', 4),
    ('Ironing Board', 9),
    ('Soccer ball', 4),
    ('Stone', 10),
    ('Swim goggles', 5),
    ('Tennis racket', 6),
    ('Tennis balls', 6),
    ('Unassigned training cones', NULL);
