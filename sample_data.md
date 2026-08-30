# Outer Join Example

These tables help illustrate the concepts of outer joins.  A sporting club has inherited some equipment and has independently voted upon the club sports that they will offer.  The problem is to identify those chosen sports that do not have equipment, and the equipment that can be sold off, since the sport is not going to be offered.

## Create and populate the tables

If desired create a new database or use an existing sample databases.

```sql
DROP DATABASE IF EXISTS sports_equipment;
CREATE DATABASE sports_equipment;
```

Add the tables and populate with sample data.

```sql
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
```

The data intentionally contains gaps:

- **Archery** and **Whitewater Rafting** have no equipment.
- **Broom, Stone** and **Ironing Board** refers to a nonexistent `sport_id`.
- **Unassigned training cones** has no associated sport.

### 1. INNER JOIN

Shows only sport with equipemtn and equipment with sport.

```sql
SELECT
    s.sport_id,
    s.sport_name,
    e.equipment_id,
    e.equipment_name
FROM sport AS s
JOIN equipment AS e
    ON e.sport_id = s.sport_id
ORDER BY s.sport_id, e.equipment_id;
```

### 2. LEFT OUTER JOIN

Shows every sport, including sports with no equipment:

```sql
SELECT
    s.sport_id,
    s.sport_name,
    e.equipment_id,
    e.equipment_name
FROM sport AS s
LEFT OUTER JOIN equipment AS e
    ON e.sport_id = s.sport_id
ORDER BY s.sport_id, e.equipment_id;
```

`Archery` appears with `NULL` equipment columns.

### 3. RIGHT OUTER JOIN

Shows every equipment item, including equipment with no matching sport:

```sql
SELECT
    s.sport_id,
    s.sport_name,
    e.equipment_id,
    e.equipment_name
FROM sport AS s
RIGHT OUTER JOIN equipment AS e
    ON e.sport_id = s.sport_id
ORDER BY e.equipment_id;
```

`Unassigned training cones` and `Mystery equipment` appear with `NULL` sport columns.

### 4. FULL OUTER JOIN

Shows all sports and all equipment, including unmatched rows on both sides:

```sql
SELECT
    s.sport_id,
    s.sport_name,
    e.equipment_id,
    e.equipment_name
FROM sport AS s
FULL OUTER JOIN equipment AS e
    ON e.sport_id = s.sport_id
ORDER BY
    s.sport_id NULLS LAST,
    e.equipment_id;
```

### 5. Find only the gaps

Sports without equipment:

```sql
SELECT
    s.sport_id,
    s.sport_name
FROM sport AS s
LEFT JOIN equipment AS e
    ON e.sport_id = s.sport_id
WHERE e.equipment_id IS NULL;
```

Equipment without a matching sport:

```sql
SELECT
    e.equipment_id,
    e.equipment_name,
    e.sport_id
FROM equipment AS e
LEFT JOIN sport AS s
    ON s.sport_id = e.sport_id
WHERE s.sport_id IS NULL;
```

In a production design, you would usually add a foreign key to `equipment.sport_id`; for demonstrating unmatched outer-join rows, the deliberately omitted constraint allows the orphaned equipment examples.