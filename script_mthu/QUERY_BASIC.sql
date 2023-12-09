--Script Nhập Hàng case 1 Mặt hàng có sẵn
BEGIN;
    update product as P set stock = P.stock + 50 where P.productid = 1;
COMMIT;

select * from product where productid = 1;

--Script Nhập Hàng case 1 Mặt hàng không sẵn
BEGIN;
INSERT INTO public.product(
	productid, name, description, price, stock, categoryid, createdby, updatedby, createdat, updatedat)
	VALUES (21, 'Bobby Diaper', 'The surface with 8,000 holes absorbs super fast to keep baby has skin dry', 50.5 , 100, 3, 'Admin', 'Admin', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
COMMIT;
select * from product where productid = 21;
--Script Kiểm tra tồn theo ngày tháng năm
select name, stock from product where date(updatedate) = '2023-08-8';
--Script xuất hàng
--Xuất 50 item Fresh Milk, 20 Oat Milk
CREATE OR REPLACE FUNCTION export_product (id_product int, export_amount int)
RETURNS boolean AS $is_export$
declare
	is_export boolean;
    amount integer;
BEGIN
   SELECT stock INTO amount FROM product AS P WHERE P.product_id = id_product;
    IF NOT FOUND THEN
        is_export := false;
        RAISE NOTICE 'Product does not exist';
    ELSE 
        IF amount >= export_amount THEN
            UPDATE product SET stock = stock - export_amount where product_id = id_product;
            is_export := true;
        ELSE
             is_export := false;
            RAISE NOTICE 'Not enough';
		END IF;
	END IF;
   RETURN is_export;
END
$is_export$ 
LANGUAGE plpgsql;

select export_product(1, 49);
--Func update vat
-- CREATE OR REPLACE FUNCTION update_vat (id_category int, value real, start_date timestamp)
-- RETURNS TABLE (category_id, vat, effective_date) AS $$
-- declare
-- 	vat_old real;
-- BEGIN
--    SELECT vat INTO vat_old FROM vat_history AS V WHERE V.category_id = id_category ORDER BY DES LIMIT 1;
--     IF NOT FOUND THEN
       
--     ELSE 
--         IF amount >= export_amount THEN
--             UPDATE product SET stock = stock - export_amount where product_id = id_product;
--             is_export := true;
--         ELSE
--              is_export := false;
--             RAISE NOTICE 'Not enough';
-- 		END IF;
-- 	END IF;
--    RETURN is_export;
-- END
-- $is_export$ 
-- LANGUAGE plpgsql;

--func create order
CREATE OR REPLACE FUNCTION create_order (id_customer int, id_employee int, id_product int[], id_camping int, id_delivery_address int, created_by VARCHAR(50), updated_by VARCHAR(50))
RETURNS TABLE (order_id, total_amount) AS $$
declare
    product_order record;
    id_product_item int;
    total_price decimal(10, 2);
    price_item decimal(10,2);
    stock_item int;
-- 	vat_old real;
BEGIN
    FOR id_product_item IN id_product LOOP
        IF NOT FOUND THEN
            RAISE NOTICE 'Not found';
            RETURN false;
        ELSE
            IF id_camping < 0 THEN

                SELECT price_item, stock_item INTO price, stock FROM product AS p WHERE p.product_id = id_product LIMIT 1;
            ELSE
                SELECT price_item, stock_item INTO price, stock FROM product AS p WHERE p.product_id = id_product LIMIT 1;
            IF stock_item > 1 THEN -- amount product
                total_price := total_price + price_item;
            ELSE 
                RAISE NOTICE 'Not enough';
                RETURN false;
            END IF;
        END IF;
    END LOOP;
    INSERT INTO public.orders(
	order_date, customer_id, employee_id, total_amount, camping_id, delivery_address_id, created_by, updated_by)
	VALUES (CURRENT_TIMESTAMP, id_customer, id_employee, id_camping, id_delivery_address, "Admin", "Admin");

   RETURN true;
END
$$ 
LANGUAGE plpgsql;




--Script xuất hoá đơn VAT
select *
from payment
inner join orders on payment.orderid = orders.orderid
inner join customer on payment.customerid = customer.customerid
inner join orderdetails on payment.orderid = orderdetails.orderid
-- Hỏi lại a Thiên chỗ này nè.
--Chọn sản phẩm -> tính tiền ->Xuất hoá đơn -> Xem lại
--Sản phẩm Organic Eggs id 2 , số lượng 5
--Người mua John id 1, người tính tiền Sophia id 10,
--Cập nhất số lượng Eggs còn lại.
update product P set stock = p.stock - 5 where productid = 2;
--Tạo hoá đơn chi tiết.
INSERT INTO Orders (OrderID, OrderDate, CustomerID, EmployeeID, TotalAmount, DeliveryAddressID, CreatedBy, UpdatedBy, CreatedAt, UpdatedAt)
values
(12, date(CURRENT_TIMESTAMP), 1, 10, 29.9, 19, 'Admin', 'Admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, CreatedBy, UpdatedBy, CreatedAt, UpdatedAt)
values
(22,12, 2, 10, 'Admin','Admin', date(CURRENT_TIMESTAMP),date(CURRENT_TIMESTAMP));
--Search sản phẩm theo danh mục và tên sản phẩm.
--Search danh mục : Instant Noodle ( id 4) & Instant Noodles - Chicken Flavor
select *
from category c full outer join product p
on c.categoryid = p.categoryid
where c.categoryid = 4
--Thống kê báo biểu
--Xuất hoá đơn đã bán trong ngày '2023-07-31'
select orderid, totalamount , createdat from orders where date(createdat) = '2023-07-31';
--Xuất hoá đơn của khách hàng John (id = 1)
select distinct orderid, firstname ,lastname, orders.createdat, orders.customerid from orders inner join customer c on orders.customerid = c.customerid where c.customerid = 1;
--Tổng tiền sản phẩm bán ra trong ngày 2023-07-31
select sum(totalamount) as doanhthu from orders where date(createdat) ='2023-07-31';
--Tổng sản phẩm bán ra trong ngày 2023-07-31
select sum(quantity) as tongsoluong from orders join orderdetails o on orders.orderid = o.orderid where date(orders.orderdate) ='2023-08-01';
--Chương trình khuyến mãi
--Mua 1 tặng 1
SELECT ROUND(3*1.0/2) ;
select sum(round(o.quantity*1.0/2) * product.price*1.0 ) as TienDaGiam from orders join orderdetails o on orders.orderid = o.orderid inner join product on o.productid =product.productid where o.orderid =11;
--Chương trình tặng thịt
--Giảm giá trên hoá đơn
--Khi đơn hàng trên 10k hỏi lại a Thiên có phải 1 orders được 1 orderdetails không nha.
--Test function
create or replace function get_product (prices float)
returns setof product
LANGUAGE plpgsql
AS
$function$
begin	return query select * from product where price > prices ;
end
$function$
select public.get_product(2);