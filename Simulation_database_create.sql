--DROP DATABASE IF EXISTS simulation_raw;
CREATE DATABASE simulation_raw;
\connect simulation_raw;

-- DROP TABLE
DROP TABLE IF EXISTS Road_friction_LLA;
DROP TABLE IF EXISTS Road_friction;
DROP TABLE IF EXISTS Vehicle CASCADE;
DROP TABLE IF EXISTS sensors;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS Contextual_Information;


-- DROP TABLE IF EXISTS bag_files;
-- DROP TABLE IF EXISTS NovAtel_gps;
-- DROP TABLE IF EXISTS Hemisphere_gps;
-- DROP TABLE IF EXISTS garmin_gps;
-- DROP TABLE IF EXISTS garmin_velocity;
-- DROP TABLE IF EXISTS Adis_IMU;
-- DROP TABLE IF EXISTS NovAtel_IMU;
-- DROP TABLE IF EXISTS laser;
-- DROP TABLE IF EXISTS encoder;
-- DROP TABLE IF EXISTS camera;
-- DROP TABLE IF EXISTS camera_parameters;
-- DROP TABLE IF EXISTS laser_parameters;
-- DROP TABLE IF EXISTS Road_friction;
-- stop here


CREATE EXTENSION postgis;
-- CREATE EXTENSION pointcloud;
-- CREATE EXTENSION pointcloud_postgis;


-- Table: airports
CREATE TABLE IF NOT EXISTS airports (
  code VARCHAR(3),
  geog GEOGRAPHY(POINT,4326)
);

INSERT INTO airports VALUES ('LAX', 'POINT(-118.4079 33.9434)');
INSERT INTO airports VALUES ('CDG', 'POINT(2.5559 49.0083)');
INSERT INTO airports VALUES ('KEF', 'POINT(-22.6056 63.9850)');


-- Table: Vehicle
CREATE TABLE IF NOT EXISTS Vehicle (
    id serial ,
    name text ,
    date_added timestamp DEFAULT CURRENT_TIMESTAMP ,
    CONSTRAINT Vehicle_pk PRIMARY KEY (id)
);

-- Table: sensors
CREATE TABLE IF NOT EXISTS sensors (
    id serial  ,
    type int  ,
    serial_number varchar(255)  ,
    company_name varchar(255)  ,
    product_name varchar(255)  ,
    date_added timestamp DEFAULT CURRENT_TIMESTAMP ,
    CONSTRAINT sensors_pk PRIMARY KEY (id)
);

-- Table: trips
CREATE TABLE IF NOT EXISTS trips (
    id serial  ,
    name text  ,
    date date  ,
    description text  ,
    passengers text  ,
    notes text  ,
    date_added timestamp  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT trips_pk PRIMARY KEY (id)
);

-- Table: Road_friction
CREATE TABLE IF NOT EXISTS Road_friction (
   id bigserial ,
   trips_id int ,
   Vehicle_id int ,
   sensors_id int ,
   Vehicle_type int ,
   idSection int ,
   segment int ,
   lane_number int ,
   idJunction int ,
   CurrentPos FLOAT ,
   position_x FLOAT ,
   position_y FLOAT ,
   position_z FLOAT ,
   positionBack_x FLOAT ,
   positionBack_y FLOAT ,
   positionBack_z FLOAT ,
   currentSpeed int ,
   direction int ,
   friction_coefficient FLOAT ,
   latitude FLOAT ,
   longitude FLOAT ,
   altitude FLOAT,
   geography GEOGRAPHY(POINT,4326) ,
   seconds bigint ,
   nanoseconds bigint ,
   time FLOAT ,
   timestamp timestamp ,
   date_added timestamp  DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT Road_friction_pk PRIMARY KEY (id)
);

CREATE INDEX roadfriction_geography_index on Road_friction USING gist (geography);

CREATE UNIQUE INDEX roadfriction_index on Road_friction (seconds ASC,nanoseconds ASC,Vehicle_id ASC,sensors_id ASC);


CREATE TABLE IF NOT EXISTS Road_friction_LLA (
   id bigserial  ,
   Road_friction_id int8  ,
   latitude FLOAT  ,
   longitude FLOAT  ,
   altitude FLOAT  ,
   geography GEOGRAPHY(POINT,4326)  ,
   date_added timestamp   DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT Road_friction_LLA_pk PRIMARY KEY (id)
);
CREATE INDEX roadfrictionlla_geography_index on Road_friction_LLA USING gist (geography ASC);



CREATE TABLE IF NOT EXISTS Contextual_Information (
   id bigserial  ,
   position_x FLOAT  ,
   position_y FLOAT  ,
   position_z FLOAT  ,
   latitude FLOAT  ,
   longitude FLOAT  ,
   altitude FLOAT  ,
   geography GEOGRAPHY(POINT,4326)  ,
   friction_coefficient FLOAT  ,
   seconds bigint  ,
   nanoseconds bigint  ,
   time FLOAT  ,
   timestamp timestamp  ,
   date_added timestamp   DEFAULT CURRENT_TIMESTAMP,
   temperature FLOAT  ,
   Roughness FLOAT  ,
   wetness FLOAT  ,
   slideNumber FLOAT  ,
   pavementType int  ,
   CONSTRAINT Contextual_Information_pk PRIMARY KEY (id)
);
CREATE INDEX context_geography_index on Contextual_Information USING gist (geography ASC);
CREATE UNIQUE INDEX context_index on Contextual_Information (seconds ASC,nanoseconds ASC);
-- End of file.










-- foreign keys
-- Reference: Road_friction_Vehicle (table: Road_friction)
ALTER TABLE Road_friction ADD CONSTRAINT Road_friction_Vehicle
    FOREIGN KEY (Vehicle_id)
    REFERENCES Vehicle (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: Road_friction_sensors (table: Road_friction)
ALTER TABLE Road_friction ADD CONSTRAINT Road_friction_sensors
    FOREIGN KEY (sensors_id)
    REFERENCES sensors (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: Road_friction_trips (table: Road_friction)
ALTER TABLE Road_friction ADD CONSTRAINT Road_friction_trips
    FOREIGN KEY (trips_id)
    REFERENCES trips (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

ALTER TABLE Road_friction_LLA ADD CONSTRAINT Road_friction_LLA_Road_friction
    FOREIGN KEY (Road_friction_id)
    REFERENCES Road_friction (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;
-- End of file.
