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

DROP TABLE IF EXISTS `northwind_dw`.`purchase_orders_staging`;

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

INSERT INTO `northwind_dw`.`purchase_orders_staging`
SELECT * FROM `northwind`.`purchase_orders_audit`;

-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`purchase_order_details_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`purchase_order_details_staging`;

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

INSERT INTO `northwind_dw`.`purchase_order_details_staging`
SELECT * FROM `northwind`.`purchase_order_details_audit`;

-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`products_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`products_staging`;

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

INSERT INTO `northwind_dw`.`products_staging`
SELECT * FROM `northwind`.`products_audit`;

-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`shippers_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`shippers_staging`;

CREATE TABLE IF NOT EXISTS `northwind_dw`.`shippers_staging` (
  `id` INT(11) NOT NULL,
  `company` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO `northwind_dw`.`shippers_staging`
SELECT * FROM `northwind`.`shippers_audit`;

-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`customers_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`customers_staging`;

CREATE TABLE IF NOT EXISTS `northwind_dw`.`customers_staging` (
  `id` INT(11) NOT NULL,
  `company` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO `northwind_dw`.`customers_staging`
SELECT * FROM `northwind`.`customers_audit`;

-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`employees_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`employees_staging`;

CREATE TABLE IF NOT EXISTS `northwind_dw`.`employees_staging` (
  `id` INT(11) NOT NULL,
  `company` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO `northwind_dw`.`employees_staging`
SELECT * FROM `northwind`.`employees_audit`;


-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`order_details_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`order_details_staging`;

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

INSERT INTO `northwind_dw`.`order_details_staging`
SELECT * FROM `northwind`.`order_details_audit`;

-- -----------------------------------------------------
-- Staging Table `northwind_dw`.`orders_staging`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `northwind_dw`.`orders_staging`;

CREATE TABLE IF NOT EXISTS `northwind_dw`.`orders_staging` (
  `id` INT(11) NOT NULL,
  `employee_id` INT(11) NULL DEFAULT NULL,
  `customer_id` INT(11) NULL DEFAULT NULL,
  `order_date` DATETIME NULL DEFAULT NULL,
  `shipped_date` DATETIME NULL DEFAULT NULL,
  `shipper_id` INT(11) NULL DEFAULT NULL,
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

INSERT INTO `northwind_dw`.`orders_staging`
SELECT * FROM `northwind`.`orders_audit`;