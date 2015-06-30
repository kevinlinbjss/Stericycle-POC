

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS stericycle;
CREATE SCHEMA stericycle;
USE stericycle;

--
-- Table structure for table `address`
--

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (address_id),
  KEY idx_fk_city_id (city_id),
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `category`
--

CREATE TABLE category (
  category_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (category_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `city`
--

CREATE TABLE city (
  city_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  city VARCHAR(50) NOT NULL,
  country_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (city_id),
  KEY idx_fk_country_id (country_id),
  CONSTRAINT `fk_city_country` FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (country_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `consumer`
--

CREATE TABLE consumer (
  consumer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacture_id TINYINT UNSIGNED NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (consumer_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Table structure for table `product_category`
--

CREATE TABLE product_category (
  product_id SMALLINT UNSIGNED NOT NULL,
  category_id TINYINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id, category_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `product_text`
--

CREATE TABLE product_text (
  product_id SMALLINT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  PRIMARY KEY  (product_id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `staff`
--

CREATE TABLE staff (
  staff_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  manufacture_id TINYINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) BINARY DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (staff_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `manufacture`
--

CREATE TABLE manufacture (
  manufacture_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  manager_staff_id TINYINT UNSIGNED NOT NULL,
  address_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (manufacture_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `event`
--

CREATE TABLE event (
  event_id SMALLINT UNSIGNED NOT NULL,
  description VARCHAR(255) NOT NULL,
  product_id TINYINT UNSIGNED NOT NULL,
  event_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (event_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `event_consumer`
--

CREATE TABLE event_consumer (
  event_id SMALLINT UNSIGNED NOT NULL,
  consumer_id TINYINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  notification_status ENUM('NOT-NOTIFIED','SUCCESSFUL','NOT-SUCCESSFUL', 'MORGUED') DEFAULT 'NOT-SUCCESSFUL',
  traceable BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (event_id, consumer_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `product`
--

CREATE TABLE product (
  product_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacture_id TINYINT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  cost DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  release_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (product_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* set delimiter */
DELIMITER $$
/* remove procedure if exists... */
DROP PROCEDURE IF EXISTS insert_manufacture_product$$
/* create procedure */ 
CREATE PROCEDURE insert_manufacture_product()
	BEGIN
	DECLARE varcount INT DEFAULT 2;
	DECLARE varmax INT DEFAULT 115;
	declare var_tmp varchar(64);
	declare var_tmp2 varchar(64);
	
	INSERT INTO product VALUES (1,1,'Depo-Medrol','A good drug','20.99','2006-02-15 05:03:42');
	INSERT INTO manufacture VALUES (1,'Pfizer, Inc',1,1,'2006-02-15 04:57:12');
    WHILE varcount <= varmax DO
		set var_tmp = concat('Company ', varcount);
		INSERT INTO manufacture VALUES (varcount,var_tmp,1,1,'2006-02-15 04:57:12');
		set var_tmp = concat('Drug name ', varcount);
		set var_tmp2 = concat('Drug desc ', varcount);
		INSERT INTO product VALUES (varcount,varcount,var_tmp,var_tmp2,'20.99','2006-02-15 05:03:42');
		SET varcount = varcount + 1; 
	END WHILE;

END $$
/* call procedure */ 



/* set delimiter */
DELIMITER $$
/* remove procedure if exists... */
DROP PROCEDURE IF EXISTS insert_events$$
/* create procedure */ 
CREATE PROCEDURE insert_events()
	BEGIN
	DECLARE varcount INT DEFAULT 1;
	DECLARE varmax INT DEFAULT 115;

	DECLARE var_event_count INT DEFAULT 1;
	DECLARE var_event_max INT DEFAULT 10;
	DECLARE var_event_desc VARCHAR(64);
	DECLARE var_event_id INT DEFAULT 1;
	declare var_tmp varchar(64);

	while var_event_count <= var_event_max do
	  set var_event_id = var_event_count + 4440;
	  set var_event_desc =  concat('event description defect #', var_event_id);
	  INSERT INTO event VALUES (var_event_id, var_event_desc,var_event_count,'2006-02-15 04:57:12');
	  set varcount = 1;
	  WHILE varcount <= varmax DO
		if varcount < 30 then
			INSERT INTO event_consumer VALUES (var_event_id, varcount,'2006-02-15 04:57:12', 'NOT-SUCCESSFUL', 0);		
		elseif varcount < 55 then
			INSERT INTO event_consumer VALUES (var_event_id, varcount,'2006-02-15 04:57:12', 'MORGUED',1);
		elseif varcount < 100 then
			INSERT INTO event_consumer VALUES (var_event_id, varcount,'2006-02-15 04:57:12', 'SUCCESSFUL', 1);
		else
			INSERT INTO event_consumer VALUES (var_event_id, varcount,'2006-02-15 04:57:12', 'NOT-NOTIFIED', 0);
		end if;
		
		SET varcount = varcount + 1;
	  end while;
	  SET var_event_count = var_event_count + 1;
	END WHILE;
END $$

/* call procedure */ 
CALL insert_manufacture_product();
CALL insert_events();


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


