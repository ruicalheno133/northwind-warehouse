delimiter //
create procedure migrar_customer()
begin
	declare done int default false;
    declare customer int;
    declare company, `name` text;
    declare cursor1 cursor for
		select distinct c.id, concat(c.first_name,' ', c.last_name) AS `name`, c.company
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
		select distinct e.id, concat(e.first_name,' ', e.last_name) AS `name`, e.company
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
		select distinct s.id, ifnull(concat(s.first_name,' ', s.last_name),'N/A') AS `name`, s.company
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
		select distinct s.id, concat(s.first_name,' ', s.last_name) AS `name`, s.company
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
		select distinct id, product_code, product_name, standard_cost, list_price, discontinued, category
        from products_staging s;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into product, prod_code, prod_name, cost, price, disc, cat;
            if done then leave read_loop;
            end if;
            
			insert into DIM_PRODUCT value 
				(null,product, product_code, prod_name, standard_cost, list_price, discontinued, category,now());
				
		end loop read_loop;

    close cursor1;
end //

delimiter //
create procedure migrar_locations()
begin
	declare done int default false;
    declare city, state, country text;
    declare cursor1 cursor for
		select distinct o.ship_city,o.ship_state_province, o.ship_country_region
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

delimiter //
create procedure migrar_facts_orders()
begin
	declare done int default false;
    declare order_id, product, employee, customer, shipper int;
    declare real_product, real_employee, real_customer, real_shipper, location, real_order_date, real_paid_date, real_shipped_date int;
    declare payment_type, city, state, country text;
    declare order_date, paid_date, shipped_date date;
    declare shipping_fee, total_price, unit_price, taxes decimal(19,4);
    declare quantity decimal(18,4);
    declare discount double;
    declare cursor1 cursor for
		select distinct od.order_id, od.product_id, od.quantity, od.unit_price, od.discount, 
						o.employee_id, o.customer_id, o.order_date, o.shipped_date, o.shipper_id,
                        o.ship_city, o.ship_state_province, o.ship_country_region, o.shipping_fee,
                        o.taxes, o.payment_type, o.paid_date
        from orders_staging o, order_details_staging od
        where o.id=od.id;
    declare continue handler for not found set done=true;
    
    open cursor1;
    
		read_loop: loop
		
			fetch cursor1 into order_id, product, quantity, unit_price, discount, 
							   employee, customer, order_date, shipped_date, shipper,
							   city, state, country, shipping_fee,
							   taxes, payment_type, paid_date;
            if done then leave read_loop;
            end if;
            
            set real_product = (select max(product_key) from DIM_PRODUCT p where p.product_id=product);
            set real_employee = (select max(employee_key) from DIM_EMPLOYEE e where e.employee_id=employee);
            set real_customer = (select max(customer_key) from DIM_CUSTOMER c where c.customer_id=customer);
            set real_order_date = (select time_key from DIM_TIME t where t.date=order_date);
            set real_shipped_date = (select time_key from DIM_TIME t where t.date=shipped_date);
            set real_shipper = (select max(shipper_key) from DIM_SHIPPER s where s.shipper_id = shipper);
            set location = (select location_key from DIM_LOCATION l where l.city = city and l.state = state and l.country = country);
			set real_paid_date = (select time_key from DIM_TIME t where t.date=paid_date);
            set total_price = (select quantity * unit_price - (quantity * unit_price) * discount from dual);
            insert into FACT_ORDER value 
				(null,order_id, real_product, real_order_date, real_shipped_date, real_paid_date, 
                real_customer, real_employee, real_shipper, location, payment_type, quantity, 
                unit_price, discount, total_price ,shipping_fee, taxes, now());
                
		end loop read_loop;

    close cursor1;
end //
