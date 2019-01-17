delimiter //
create procedure migrar_customer()
begin
	declare done int default false;
    declare customer int;
    declare company, `name` text;
    declare cursor1 cursor for
		select distinct c.id, ifnull(concat(c.first_name,' ', c.last_name),'N/A') AS `name`, ifnull(c.company,'N/A')
        from customers_staging c;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into customer, `name`, company;
            if done then leave read_loop;
            end if;
			insert into DIM_CUSTOMER value 
				(null,customer,company,`name`,now());
				
		end loop read_loop;

    close cursor1;
end //

delimiter //
create procedure migrar_employee()
begin
	declare done int default false;
    declare employee int;
    declare company, `name` text;
    declare cursor1 cursor for
		select distinct e.id, ifnull(concat(e.first_name,' ', e.last_name),'N/A') AS `name`, ifnull(e.company,'N/A')
        from employees_staging e;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into employee, `name`, company;
            if done then leave read_loop;
            end if;
			insert into DIM_EMPLOYEE value 
				(null,employee,company,`name`,now());
				
		end loop read_loop;

    close cursor1;
end //

delimiter //
create procedure migrar_shipper()
begin
	declare done int default false;
    declare shipper int;
    declare company, `name` text;
    declare cursor1 cursor for
		select distinct s.id, ifnull(concat(s.first_name,' ', s.last_name),'N/A') AS `name`, ifnull(s.company,'N/A')
        from shippers_staging s;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into shipper, `name`, company;
            if done then leave read_loop;
            end if;
		
			insert into DIM_SHIPPER value 
				(null,shipper,company,`name`,now());
				
		end loop read_loop;

    close cursor1;
end //

delimiter //
create procedure migrar_suppliers()
begin
	declare done int default false;
    declare supplier int;
    declare company, `name` text;
    declare cursor1 cursor for
		select distinct s.id, ifnull(concat(s.first_name,' ', s.last_name),'N/A') AS `name`, ifnull(s.company,'N/A')
        from suppliers_staging s;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into supplier, `name`, company;
            if done then leave read_loop;
            end if;
            
			insert into DIM_SUPPLIER value 
				(null,supplier,company,`name`,now());
				
		end loop read_loop;

    close cursor1;
end //

delimiter //
create procedure migrar_products()
begin
	declare done int default false;
    declare product, disc int;
    declare cost, price decimal;
    declare prod_code, prod_name, cat text;
    declare cursor1 cursor for
		select distinct id, ifnull(product_code,'N/A') , ifnull(product_name,'N/A') , ifnull(standard_cost,-1), list_price, discontinued, ifnull(category,'N/A')
        from products_staging s;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into product, prod_code, prod_name, cost, price, disc, cat;
            if done then leave read_loop;
            end if;
            
			insert into DIM_PRODUCT value 
				(null,product, prod_code, prod_name, cost, price, disc, cat,now());
				
		end loop read_loop;

    close cursor1;
end //

delimiter //
create procedure migrar_locations()
begin
	declare done int default false;
    declare city, state, country text;
    declare cursor1 cursor for
		select distinct ifnull(o.ship_city,'N/A'),ifnull(o.ship_state_province,'N/A'), ifnull(o.ship_country_region,'N/A')
        from orders_staging o;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into city, state, country;
            if done then leave read_loop;
            end if;
			insert into DIM_LOCATION value 
				(null, city, state, country,now());
                
		end loop read_loop;

    close cursor1;
end //

DELIMITER //
CREATE FUNCTION isWeekday(adate DATE)
RETURNS TINYINT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE isw TINYINT;
    IF
        DAYOFWEEK(adate) = 7 OR DAYOFWEEK(adate) = 1
    THEN
        SET isw = 0;
    ELSE 
        SET isw = 1;
    END IF;
    RETURN isw;
END;
//


DELIMITER //
CREATE PROCEDURE migrar_time()
  BEGIN
    DECLARE adate DATE;
    SET aDate = (select '2006-01-01' from dual);
    WHILE adate <= '2007-01-01' DO
      INSERT INTO DIM_TIME 
        VALUE(
          null,
          DATE(adate),
          YEAR(adate),
          MONTH(adate),
          WEEKOFYEAR(adate),
          DAYOFMONTH(adate),
          DAYNAME((adate)),
          isWeekday(adate),
          now()
        );
      SET adate = date_add(adate, INTERVAL 1 DAY);
    END WHILE;
    INSERT INTO DIM_TIME
      VALUE(
      -1,
      DATE('1901-01-01'),
      YEAR('1901-01-01'),
      MONTH('1901-01-01'),
      WEEKOFYEAR('1901-01-01'),
      DAYOFMONTH('1901-01-01'),
      DAYNAME('1901-01-01'),
      isWeekday('1901-01-01'),
      now()
      );
  END; //
DELIMITER ;

delimiter //
create procedure migrar_facts_orders()
begin
	declare done int default false;
    declare order_id, product, employee, customer, shipper int;
    declare real_product, real_employee, real_customer, real_shipper, location, real_order_date, real_paid_date, real_shipped_date int;
    declare payment, city, state, country text;
    declare order_d, paid_d, shipped_d date;
    declare fee, total_price, price, taxe decimal(19,4);
    declare quant decimal(18,4);
    declare disc double;
    declare cursor1 cursor for
		select distinct od.order_id, od.product_id, od.quantity, ifnull(od.unit_price,'N/A'), od.discount, 
						o.employee_id, o.customer_id, o.order_date, o.shipped_date, o.shipper_id,
                        o.ship_city, o.ship_state_province, o.ship_country_region, ifnull(o.shipping_fee,'N/A'),
                        ifnull(o.taxes,'N/A'), ifnull(o.payment_type,'N/A'), o.paid_date
        from orders_staging o, order_details_staging od
        where o.id=od.order_id and o.shipper_id is not null;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into order_id, product, quant, price, disc, 
							   employee, customer, order_d, shipped_d, shipper,
							   city, state, country, fee,
							   taxe, payment, paid_d;
            if done then leave read_loop;
            end if;
            
            set real_product = (select max(product_key) from DIM_PRODUCT p where p.product_id=product);
            set real_employee = (select max(employee_key) from DIM_EMPLOYEE e where e.employee_id=employee);
            set real_customer = (select max(customer_key) from DIM_CUSTOMER c where c.customer_id=customer);
            set real_order_date = (select time_key from DIM_TIME t where t.date=order_d);
            set real_shipped_date = (select time_key from DIM_TIME t where t.date=shipped_d);
            set real_shipper = (select max(shipper_key) from DIM_SHIPPER s where s.shipper_id = shipper);
            set location = (select location_key from DIM_LOCATION l where l.city = city and l.state = state and l.country = country);
			set real_paid_date = (select time_key from DIM_TIME t where t.date=paid_d);
            set total_price = (select quant * price - (quant * price) * disc from dual);
            
            insert into FACT_ORDER value 
				(null,order_id, real_product, ifnull(real_order_date,-1), ifnull(real_shipped_date,-1), 
                ifnull(real_paid_date,-1), real_customer, real_employee, real_shipper, location, 
                payment, quant, price, disc, total_price ,fee, taxe);
                
		end loop read_loop;

    close cursor1;
end //

drop procedure migrar_facts_purchases;

delimiter //
create procedure migrar_facts_purchases()
begin
	declare done int default false;
    declare purchase_id, product, submitted, supplier, delay int;
    declare real_product, real_employee, real_supplier, real_received_date, real_payment_date, real_submitted_date, real_expected_date int;
    declare payment text;
    declare received_d, submitted_d, expected_d, payment_d date;
    declare fee, cost, taxe, amount decimal(19,4);
    declare quant decimal(18,4);
    declare cursor1 cursor for
		select distinct pd.purchase_order_id, pd.product_id, pd.quantity, ifnull(pd.unit_cost,'N/A'), pd.date_received, 
						p.supplier_id, p.submitted_date, p.expected_date, ifnull(p.shipping_fee,'N/A'),
                        ifnull(p.taxes,'N/A'), p.payment_date, p.payment_amount, p.submitted_by
        from purchase_orders_staging p, purchase_order_details_staging pd
        where p.id=pd.purchase_order_id;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into purchase_id, product, quant, cost, received_d, supplier, 
							   submitted_d, expected_d, fee, taxe, payment_d, amount, submitted;
            if done then leave read_loop;
            end if;
            
            set real_product = (select max(product_key) from DIM_PRODUCT p where p.product_id=product);
            set real_employee = (select max(employee_key) from DIM_EMPLOYEE e where e.employee_id=submitted);
            set real_received_date = (select time_key from DIM_TIME t where t.date=received_d);
            set real_submitted_date = (select time_key from DIM_TIME t where t.date=submitted_d);
            set real_supplier = (select max(supplier_key) from DIM_SUPPLIER s where s.supplier_id = supplier);
            set real_expected_date = (select time_key from DIM_TIME t where t.date=expected_d);
            set real_payment_date = (select time_key from DIM_TIME t where t.date=payment_d);
            set delay = (select real_received_date-real_expected_date from dual);
            
            insert into FACT_PURCHASE value 
				(null,purchase_id, real_supplier, real_employee, real_product, ifnull(real_expected_date,-1),
                ifnull(real_received_date,-1), ifnull(real_submitted_date,-1),ifnull(real_payment_date,-1),
                quant, cost, amount, ifnull(delay,-1), fee, taxe);
                
		end loop read_loop;

    close cursor1;
end //

