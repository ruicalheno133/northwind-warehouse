SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema northwind_dw
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `northwind_dw` DEFAULT CHARACTER SET utf8 ;
USE `northwind_dw` ;

-- -----------------------------------------------------
-- Table `northwind_dw`.`DIM_TIME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`DIM_TIME` (
  `time_key` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `year` YEAR NOT NULL,
  `month` INT NOT NULL,
  `week` INT NOT NULL,
  `day` INT NOT NULL,
  `day_of_the_week` VARCHAR(3) NOT NULL,
  `is_week_day` TINYINT NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`time_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`DIM_CUSTOMER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`DIM_CUSTOMER` (
  `customer_key` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `company` VARCHAR(50) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`customer_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`DIM_PRODUCT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`DIM_PRODUCT` (
  `product_key` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `product_code` VARCHAR(25) NOT NULL,
  `product_name` VARCHAR(50) NOT NULL,
  `standard_cost` DECIMAL(19,4) NOT NULL,
  `list_price` DECIMAL(19,4) NOT NULL,
  `discontinued` TINYINT(1) NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`product_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`DIM_EMPLOYEE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`DIM_EMPLOYEE` (
  `employee_key` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `company` VARCHAR(50) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`employee_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`DIM_SUPPLIER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`DIM_SUPPLIER` (
  `supplier_key` INT NOT NULL AUTO_INCREMENT,
  `supplier_id` INT NOT NULL,
  `company` VARCHAR(50) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`supplier_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`DIM_SHIPPER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`DIM_SHIPPER` (
  `shipper_key` INT NOT NULL AUTO_INCREMENT,
  `shipper_id` INT NOT NULL,
  `company` VARCHAR(50) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `created_date` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`shipper_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`DIM_LOCATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`DIM_LOCATION` (
  `location_key` INT NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(50) NOT NULL,
  `state` VARCHAR(50) NOT NULL,
  `country` VARCHAR(50) NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`location_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`FACT_ORDER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`FACT_ORDER` (
  `order_key` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `product_key` INT NOT NULL,
  `order_date` INT NOT NULL,
  `shipped_date` INT NOT NULL,
  `paid_date` INT NOT NULL,
  `customer_key` INT NOT NULL,
  `employee_key` INT NOT NULL,
  `shipper_key` INT NOT NULL,
  `ship_location` INT NOT NULL,
  `payment_type` VARCHAR(50) NOT NULL,
  `quantity` DECIMAL(18,4) NOT NULL,
  `unit_price` DECIMAL(19,4) NOT NULL,
  `discount` DOUBLE NOT NULL,
  `total_price` DECIMAL(19,4) NOT NULL,
  PRIMARY KEY (`order_key`),
  INDEX `fk_FACT_ORDER_1_idx` (`order_date` ASC),
  INDEX `fk_FACT_ORDER_2_idx` (`shipped_date` ASC),
  INDEX `fk_FACT_ORDER_3_idx` (`paid_date` ASC),
  INDEX `fk_FACT_ORDER_4_idx` (`shipper_key` ASC),
  INDEX `fk_FACT_ORDER_5_idx` (`ship_location` ASC),
  INDEX `fk_FACT_ORDER_6_idx` (`customer_key` ASC),
  INDEX `fk_FACT_ORDER_7_idx` (`employee_key` ASC),
  INDEX `fk_FACT_ORDER_8_idx` (`product_key` ASC),
  CONSTRAINT `fk_FACT_ORDER_1`
    FOREIGN KEY (`order_date`)
    REFERENCES `northwind_dw`.`DIM_TIME` (`time_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_ORDER_2`
    FOREIGN KEY (`shipped_date`)
    REFERENCES `northwind_dw`.`DIM_TIME` (`time_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_ORDER_3`
    FOREIGN KEY (`paid_date`)
    REFERENCES `northwind_dw`.`DIM_TIME` (`time_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_ORDER_4`
    FOREIGN KEY (`shipper_key`)
    REFERENCES `northwind_dw`.`DIM_SHIPPER` (`shipper_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_ORDER_5`
    FOREIGN KEY (`ship_location`)
    REFERENCES `northwind_dw`.`DIM_LOCATION` (`location_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_ORDER_6`
    FOREIGN KEY (`customer_key`)
    REFERENCES `northwind_dw`.`DIM_CUSTOMER` (`customer_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_ORDER_7`
    FOREIGN KEY (`employee_key`)
    REFERENCES `northwind_dw`.`DIM_EMPLOYEE` (`employee_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_ORDER_8`
    FOREIGN KEY (`product_key`)
    REFERENCES `northwind_dw`.`DIM_PRODUCT` (`product_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `northwind_dw`.`FACT_PURCHASE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `northwind_dw`.`FACT_PURCHASE` (
  `purchase_key` INT NOT NULL AUTO_INCREMENT,
  `purchase_id` INT NOT NULL,
  `supplier_key` INT NOT NULL,
  `employee_key` INT NOT NULL,
  `product_key` INT NOT NULL,
  `expected_date` INT NOT NULL,
  `date_received` INT NOT NULL,
  `submitted_date` INT NOT NULL,
  `payment_date` INT NOT NULL,
  `quantity` DECIMAL(18,4) NOT NULL,
  `unit_cost` DECIMAL(19,4) NOT NULL,
  `payment_amount` VARCHAR(45) NOT NULL,
  `delivery_delay` INT NOT NULL,
  `shipping_fee` DECIMAL(19,4) NOT NULL,
  `taxes` DECIMAL(19,4) NOT NULL,
  PRIMARY KEY (`purchase_key`),
  INDEX `fk_FACT_PURCHASE_1_idx` (`supplier_key` ASC),
  INDEX `fk_FACT_PURCHASE_2_idx` (`employee_key` ASC),
  INDEX `fk_FACT_PURCHASE_3_idx` (`product_key` ASC),
  INDEX `fk_FACT_PURCHASE_4_idx` (`expected_date` ASC),
  INDEX `fk_FACT_PURCHASE_5_idx` (`date_received` ASC),
  INDEX `fk_FACT_PURCHASE_6_idx` (`submitted_date` ASC),
  INDEX `fk_FACT_PURCHASE_7_idx` (`payment_date` ASC),
  CONSTRAINT `fk_FACT_PURCHASE_1`
    FOREIGN KEY (`supplier_key`)
    REFERENCES `northwind_dw`.`DIM_SUPPLIER` (`supplier_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_PURCHASE_2`
    FOREIGN KEY (`employee_key`)
    REFERENCES `northwind_dw`.`DIM_EMPLOYEE` (`employee_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_PURCHASE_3`
    FOREIGN KEY (`product_key`)
    REFERENCES `northwind_dw`.`DIM_PRODUCT` (`product_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_PURCHASE_4`
    FOREIGN KEY (`expected_date`)
    REFERENCES `northwind_dw`.`DIM_TIME` (`time_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_PURCHASE_5`
    FOREIGN KEY (`date_received`)
    REFERENCES `northwind_dw`.`DIM_TIME` (`time_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_PURCHASE_6`
    FOREIGN KEY (`submitted_date`)
    REFERENCES `northwind_dw`.`DIM_TIME` (`time_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FACT_PURCHASE_7`
    FOREIGN KEY (`payment_date`)
    REFERENCES `northwind_dw`.`DIM_TIME` (`time_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`suppliers_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`suppliers_staging`;

CREATE TABLE IF NOT EXISTS `northwind_dw`.`suppliers_staging` (
  `id` INT(11) NOT NULL,
  `company` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO `northwind_dw`.`suppliers_staging`
SELECT * FROM `northwind`.`suppliers_audit`;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`purchase_orders_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`purchase_orders_staging` (
  `id` INT(11) NOT NULL,
  `supplier_id` INT(11) NULL DEFAULT NULL,
  `submitted_date` DATETIME NULL DEFAULT NULL,
  `expected_date` DATETIME NULL DEFAULT NULL,
  `shipping_fee` DECIMAL(19,4) NOT NULL DEFAULT '0.0000',
  `taxes` DECIMAL(19,4) NOT NULL DEFAULT '0.0000',
  `payment_date` DATETIME NULL DEFAULT NULL,
  `payment_amount` DECIMAL(19,4) NULL DEFAULT '0.0000',
  `submitted_by` INT(11) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`purchase_order_details_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`purchase_order_details_staging` (
  `id` INT(11) NOT NULL,
  `purchase_order_id` INT(11) NOT NULL,
  `product_id` INT(11) NULL DEFAULT NULL,
  `quantity` DECIMAL(18,4) NOT NULL,
  `unit_cost` DECIMAL(19,4) NOT NULL,
  `date_received` DATETIME NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`products_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`products_staging` (
  `id` INT(11) NOT NULL,
  `product_code` VARCHAR(25) NULL DEFAULT NULL,
  `product_name` VARCHAR(50) NULL DEFAULT NULL,
  `standard_cost` DECIMAL(19,4) NULL DEFAULT '0.0000',
  `list_price` DECIMAL(19,4) NOT NULL DEFAULT '0.0000',
  `discontinued` TINYINT(1) NOT NULL DEFAULT '0',
  `category` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`shippers_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`shippers_staging` (
  `id` INT(11) NOT NULL,
  `company` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`customers_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`customers_staging` (
  `id` INT(11) NOT NULL,
  `company` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`employees_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`employees_staging` (
  `id` INT(11) NOT NULL,
  `company` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`order_details_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`order_details_staging` (
  `id` INT(11) NOT NULL,
  `order_id` INT(11) NOT NULL,
  `product_id` INT(11) NULL DEFAULT NULL,
  `quantity` DECIMAL(18,4) NOT NULL DEFAULT '0.0000',
  `unit_price` DECIMAL(19,4) NULL DEFAULT '0.0000',
  `discount` DOUBLE NOT NULL DEFAULT '0'
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`orders_staging`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `northwind_dw`.`orders_staging` (
  `id` INT(11) NOT NULL,
  `employee_id` INT(11) NULL DEFAULT NULL,
  `customer_id` INT(11) NULL DEFAULT NULL,
  `order_date` DATETIME NULL DEFAULT NULL,
  `shipped_date` DATETIME NULL DEFAULT NULL,
  `shipper_id` INT(11) NULL DEFAULT NULL,
  `ship_address` LONGTEXT NULL DEFAULT NULL,
  `ship_city` VARCHAR(50) NULL DEFAULT NULL,
  `ship_state_province` VARCHAR(50) NULL DEFAULT NULL,
  `ship_country_region` VARCHAR(50) NULL DEFAULT NULL,
  `shipping_fee` DECIMAL(19,4) NULL DEFAULT '0.0000',
  `taxes` DECIMAL(19,4) NULL DEFAULT '0.0000',
  `payment_type` VARCHAR(50) NULL DEFAULT NULL,
  `paid_date` DATETIME NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
