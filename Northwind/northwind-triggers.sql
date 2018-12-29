DELIMITER //

-- ---------------------------------------------------
-- Atualiza tabela de auditoria SUPPLIERS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela SUPPLIERS
-- ---------------------------------------------------

CREATE TRIGGER audit_ins_suppliers
AFTER INSERT ON northwind.suppliers
FOR EACH ROW 
BEGIN
	CALL update_audit_suppliers(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE TRIGGER audit_upd_suppliers
AFTER UPDATE ON northwind.suppliers
FOR EACH ROW 
BEGIN
	CALL update_audit_suppliers(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE PROCEDURE update_audit_suppliers (IN id INT, IN company VARCHAR(50), IN last_name VARCHAR(50), IN first_name VARCHAR(50))
BEGIN 
	INSERT INTO northwind.suppliers_audit
	VALUES (id, company, last_name, first_name);
END//

-- ---------------------------------------------------
-- Atualiza tabela de auditoria SHIPPERS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela SHIPPERS
-- ---------------------------------------------------

CREATE TRIGGER audit_ins_shippers
AFTER INSERT ON northwind.shippers
FOR EACH ROW 
BEGIN
	CALL update_audit_shippers(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE TRIGGER audit_upd_shippers
AFTER UPDATE ON northwind.shippers
FOR EACH ROW 
BEGIN
	CALL update_audit_shippers(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE PROCEDURE update_audit_shippers (IN id INT, IN company VARCHAR(50), IN last_name VARCHAR(50), IN first_name VARCHAR(50))
BEGIN 
	INSERT INTO northwind.shippers_audit
	VALUES (id, company, last_name, first_name);
END//


-- ---------------------------------------------------
-- Atualiza tabela de auditoria CUSTOMERS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela CUSTOMERS
-- ---------------------------------------------------

CREATE TRIGGER audit_ins_customers
AFTER INSERT ON northwind.customers
FOR EACH ROW 
BEGIN
	CALL update_audit_customers(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE TRIGGER audit_upd_customers
AFTER UPDATE ON northwind.customers
FOR EACH ROW 
BEGIN
	CALL update_audit_customers(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE PROCEDURE update_audit_customers (IN id INT, IN company VARCHAR(50), IN last_name VARCHAR(50), IN first_name VARCHAR(50))
BEGIN 
	INSERT INTO northwind.customers_audit
	VALUES (id, company, last_name, first_name);
END//


-- ---------------------------------------------------
-- Atualiza tabela de auditoria EMPLOYEES_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela EMPLOYEES
-- ---------------------------------------------------

CREATE TRIGGER audit_ins_employees
AFTER INSERT ON northwind.employees
FOR EACH ROW 
BEGIN
	CALL update_audit_employees(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE TRIGGER audit_upd_employees
AFTER UPDATE ON northwind.employees
FOR EACH ROW 
BEGIN
	CALL update_audit_employees(NEW.id, NEW.company, NEW.last_name, NEW.first_name);
END//

CREATE PROCEDURE update_audit_employees (IN id INT, IN company VARCHAR(50), IN last_name VARCHAR(50), IN first_name VARCHAR(50))
BEGIN 
	INSERT INTO northwind.employees_audit
	VALUES (id, company, last_name, first_name);
END//


-- ---------------------------------------------------
-- Atualiza tabela de auditoria PRODUCTS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela PRODUCTS
-- ---------------------------------------------------

CREATE TRIGGER audit_ins_products
AFTER INSERT ON northwind.products
FOR EACH ROW 
BEGIN
	CALL update_audit_products(NEW.id, NEW.product_name, NEW.product_name, NEW.standard_cost, NEW.list_price, NEW.discontinued, NEW.category);
END//

CREATE TRIGGER audit_upd_products
AFTER UPDATE ON northwind.products
FOR EACH ROW 
BEGIN
	CALL update_audit_products(NEW.id, NEW.product_name, NEW.product_name, NEW.standard_cost, NEW.list_price, NEW.discontinued, NEW.category);
END//

CREATE PROCEDURE update_audit_products (IN id INT, IN code VARCHAR(25), IN name VARCHAR(50), IN standard_cost DECIMAL(19,4), 
												   IN list_price DECIMAL(19,4), IN discontinued TINYINT(1), IN category VARCHAR(50))
BEGIN 
	INSERT INTO northwind.products_audit
	VALUES (id, code, name, standard_cost, list_price, discontinued, category);
END//


-- ---------------------------------------------------
-- Atualiza tabela de auditoria PURCHASE_ORDER_DETAILS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela PURCHASE_ORDER_DETAILS_ORDERS
-- ---------------------------------------------------

CREATE TRIGGER audit_ins_purchase_order_details
AFTER INSERT ON northwind.purchase_order_details
FOR EACH ROW 
BEGIN
	CALL update_audit_purchase_order_details(NEW.id, NEW.purchase_order_id, NEW.product_id, NEW.quantity, NEW.unit_cost, NEW.date_received);
END//

CREATE TRIGGER audit_upd_purchase_order_details
AFTER UPDATE ON northwind.purchase_order_details
FOR EACH ROW 
BEGIN
	CALL update_audit_purchase_order_details(NEW.id, NEW.purchase_order_id, NEW.product_id, NEW.quantity, NEW.unit_cost, NEW.date_received);
END//

CREATE PROCEDURE update_audit_purchase_order_details (IN id INT, IN purchase_order_id INT, IN product_id INT, IN quantity DECIMAL(18,4), 
												   IN unit_cost DECIMAL(19,4), IN date_received DATETIME)
BEGIN 
	INSERT INTO northwind.purchase_order_details_audit
	VALUES (id, purchase_order_id, product_id, quantity, unit_cost, date_received);
END//


-- ---------------------------------------------------
-- Atualiza tabela de auditoria PURCHASE_ORDERS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela PURCHASE_ORDERS
-- ---------------------------------------------------
-- 
CREATE TRIGGER audit_ins_purchase_orders
AFTER INSERT ON northwind.purchase_orders
FOR EACH ROW 
BEGIN
	CALL update_audit_purchase_orders(NEW.id, NEW.supplier_id, NEW.submitted_date, NEW.expected_date, NEW.shipping_fee, NEW.taxes,
										 NEW.payment_date, NEW.payment_amount, NEW.submitted_by);
END//

CREATE TRIGGER audit_upd_purchase_orders
AFTER UPDATE ON northwind.purchase_orders
FOR EACH ROW 
BEGIN
	CALL update_audit_purchase_orders(NEW.id, NEW.supplier_id, NEW.submitted_date, NEW.expected_date, NEW.shipping_fee, NEW.taxes,
										 NEW.payment_date, NEW.payment_amount, NEW.submitted_by);
END//

CREATE PROCEDURE update_audit_purchase_orders (IN id INT, IN supplier_id INT, IN submitted_date DATETIME, IN expected_date DATETIME, 
												   IN shipping_fee DECIMAL(19,4), IN taxes DECIMAL(19,4), IN payment_date DATETIME, 
												   IN payment_amount DECIMAL(19,4), IN submitted_by INT)
BEGIN 
	INSERT INTO northwind.purchase_orders_audit
	VALUES (id, supplier_id, submitted_date, expected_date, shipping_fee, taxes, payment_date, payment_amount, submitted_date);
END//


-- ---------------------------------------------------
-- Atualiza tabela de auditoria ORDERS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela ORDERS
-- ---------------------------------------------------

CREATE TRIGGER audit_ins_orders
AFTER INSERT ON northwind.orders
FOR EACH ROW 
BEGIN
	CALL update_audit_orders(NEW.id, NEW.employee_id, NEW.customer_id, NEW.order_date, NEW.shipped_date, NEW.shipper_id, 
									 NEW.ship_address, NEW.ship_city, NEW.ship_state_province, NEW.ship_country_region, NEW.shipping_fee, 
									 NEW.taxes, NEW.payment_type, NEW.paid_date);
END//

CREATE TRIGGER audit_upd_orders
AFTER UPDATE ON northwind.orders
FOR EACH ROW 
BEGIN
	CALL update_audit_orders(NEW.id, NEW.employee_id, NEW.customer_id, NEW.order_date, NEW.shipped_date, NEW.shipper_id, 
									 NEW.ship_address, NEW.ship_city, NEW.ship_state_province, NEW.ship_country_region, NEW.shipping_fee, 
									 NEW.taxes, NEW.payment_type, NEW.paid_date);
END//

CREATE PROCEDURE update_audit_orders (IN id INT, IN employee_id INT, IN customer_id INT, IN order_date DATETIME, IN shipped_date DATETIME, 
											  IN shipper_id INT, IN ship_address LONGTEXT, IN ship_city VARCHAR(50), IN ship_state_province VARCHAR(50),
											  IN ship_country_region VARCHAR(50), IN shipping_fee DECIMAL(19,4), IN taxes DECIMAL(19,4), IN payment_type VARCHAR(50), 
											  IN paid_date DATETIME)
BEGIN 
	INSERT INTO northwind.orders_audit
	VALUES (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_address, ship_city, ship_state_province,
			ship_country_region, shipping_fee, taxes, payment_type, paid_date);
END//


-- ---------------------------------------------------
-- Atualiza tabela de auditoria ORDER_DETAILS_AUDIT
-- quando um novo registo é inserido ou atualizado 
-- na tabela ORDER_DETAILS
-- -------------------------------------------------

CREATE TRIGGER audit_ins_order_details
AFTER INSERT ON northwind.order_details
FOR EACH ROW 
BEGIN
	CALL update_audit_order_details(NEW.id, NEW.order_id, NEW.product_id, NEW.quantity, NEW.unit_price, NEW.discount);
END//

CREATE TRIGGER audit_upd_order_details
AFTER UPDATE ON northwind.order_details
FOR EACH ROW 
BEGIN
	CALL update_audit_order_details(NEW.id, NEW.order_id, NEW.product_id, NEW.quantity, NEW.unit_price, NEW.discount);
END//

CREATE PROCEDURE update_audit_order_details (IN id INT, IN order_id INT, IN product_id INT, IN quantity DECIMAL(18,4), IN unit_price DECIMAL(19,4), 
											  IN discount DOUBLE)
BEGIN 
	INSERT INTO northwind.order_details_audit
	VALUES (id, order_id, product_id, quantity, unit_price, discount);
END//