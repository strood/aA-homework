CREATE TABLE countries(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    population INTEGER NOT NULL
);

CREATE TABLE animals(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country_id INTEGER NOT NULL,

    FOREIGN KEY (country_id) REFERENCES countries(id) 
);

-- Whenever creating a table with a foreign key, you must specify which table's
--  primary key is being referenced.

-- Adding a FOREIGN KEY constraint prevents actions that would destroy links 
-- between tables, and also stops invalid data from being inserted into the 
-- foreign key column e.g. you cannot not insert a country_id in animals that
--  does not match an existing id in countries.


-- INSERT INTO

-- Next, add some entries to your animals table.

-- Below we are using a SQL query to find the id of an existing row in our
--  countries table to populate the country_id:


INSERT INTO 
    countries
    (name, population)
VALUES
    ('United States', 327000000)
;


INSERT INTO 
    animals
    (name, country_id)
VALUES
    ('Racoon',
    (SELECT id
    FROM countries
    WHERE name = 'United States')),
    ('Black Bear',
    (SELECT id
    FROM countries
    WHERE name = 'United States'))
;

-- DROP TABLE
-- Your file is almost ready for importing, however there is one final and
--  important step.

-- In order to prevent duplicate data being inserted whenever you import this
--  file, you must first drop your tables to destroy any data stored in them.

-- Order is important when dropping tables. The database constraints we have
--  in place will prevent a single country from being deleted if any animal
--  has a foreign key referencing that country. These same restraints will
--  also prevent a table being dropped should it be referenced by any other
--  table in our database.

-- For this reason, you must drop any tables with foreign key restraints
--  first:
-- deleted these lines after being told to add, didnt make sense?
-- DROP TABLE animals;
-- DROP TABLE countries;