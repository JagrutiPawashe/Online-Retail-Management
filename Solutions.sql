# 1. Find the store with the highest customer grade.
SELECT sid, name, customerGrade
FROM Store
ORDER BY customerGrade DESC
LIMIT 1;

#2. Find the product that has been ordered the most times.
SELECT pid, name, COUNT(*) AS totalOrders
FROM OrderItem
Join product
using(pid)
GROUP BY pid
ORDER BY totalOrders DESC
LIMIT 1;

#3. Find all the orders that were delivered to addresses in the city of Cornwall
SELECT o.orderNumber, creationTime, totalAmount
FROM orders as o
JOIN Deliver_To as d
ON o.orderNumber = d.orderNumber
JOIN Address as a
ON d.addrid = a.addrid
WHERE city = 'Cornwall';

#4. Find all the orders that were placed for products that are sold by stores in the city of Toronto.
SELECT orderNumber, orders.creationTime, totalAmount
FROM Orders
JOIN OrderItem
ON Orders.creationTime = OrderItem.creationTime
JOIN Product
ON OrderItem.pid = Product.pid
JOIN Store
ON Product.sid = Store.sid
WHERE city = 'Toronto';

#5. Find all the orders that were placed for products that have a customer review rating of at least 4 out of 5 stars
SELECT orderitem.itemid,product.brand, product.name,product.amount
FROM OrderItem
JOIN Product
ON OrderItem.pid = Product.pid
JOIN comments
ON product.pid = comments.pid
WHERE grade >= 4;

#6. Find all the details of the buyers who have a phone number that starts with the contactnumber 91.
SELECT Users.*
FROM Users
JOIN Buyer
ON Users.userId = Buyer.userId
WHERE phoneNumber LIKE '91%';

#7. Query the address, starttime and endtime of the servicepoints in the same city as userid 5   
SELECT streetaddr,starttime,endtime
FROM ServicePoint
WHERE ServicePoint.city IN (SELECT Address.city FROM Address WHERE userid=5);

#8. Query the information of laptops
SELECT *
FROM Product
WHERE type='laptop';

#9. Query the total quantity of products from store with storeid 8 in the shopping cart
SELECT SUM(quantity) AS totalQuantity
FROM Save_to_Shopping_Cart
WHERE pid IN (SELECT pid FROM Product WHERE sid=8);

#10. Query the name and address of orders delivered on 2017-02-17
SELECT name, streetaddr, city
FROM Address
WHERE addrid IN (SELECT addrid FROM Deliver_To WHERE TimeDelivered = '2017-02-17');

#11. Update the payment state of orders to unpaid which created after year 2017 and with total amount greater than 50.

UPDATE Orders
SET paymentState = 'Unpaid'
WHERE creationTime > '2017-01-01' AND totalAmount > 50;

#12. Update the name and contact phone number of address where the provice is Quebec and city is montreal.

UPDATE address
SET name = 'Awesome Lady', contactPhoneNumber ='1234567'
WHERE province = 'Quebec' AND city = 'Montreal';

#13. Delete the store which opened before year 2017
DELETE FROM save_to_shopping_cart
WHERE addTime < '2017-01-01';

#14. Create view of all products whose price above average price.

CREATE VIEW Products_Above_Average_Price AS
SELECT pid, name, price 
FROM Product
WHERE price > (SELECT AVG(price) FROM Product);

select * from products_above_average_price;

#15. Create view of all products sales in 2016.
CREATE VIEW Product_Sales_For_2016 AS
SELECT pid, name, price
FROM Product
WHERE pid IN (SELECT pid FROM OrderItem WHERE itemid IN 
              (SELECT itemid FROM Contain WHERE orderNumber IN
               (SELECT orderNumber FROM Payment WHERE payTime > '2016-01-01' AND payTime < '2016-12-31')
              )
             );

SELECT * FROM product_sales_for_2016;

#16. Retrieve the shopping cart items for a specific buyer
SELECT p.* FROM Product as p
JOIN Save_to_Shopping_Cart as sc ON p.pid = sc.pid
JOIN Buyer as b
ON sc.userid = b.userid;

#17. Create a view that shows the list of products in the shopping cart for each buyer
CREATE VIEW ShoppingCartView AS
SELECT u.userId, u.name AS buyerName, p.*
FROM Users as u
JOIN Save_to_Shopping_Cart as sc ON u.userId = sc.userid
JOIN Product p ON sc.pid = p.pid;

#18. Create a view that presents the order details along with the corresponding delivery address
CREATE VIEW OrderAddressView AS
SELECT o.orderNumber, o.creationTime, o.paymentState, o.totalAmount, a.*
FROM Orders as o
JOIN Deliver_To  as dt ON o.orderNumber = dt.orderNumber
JOIN Address a ON dt.addrid = a.addrid;

#19. Retrieve all credit card payments and their associated order information
SELECT cc.*, o.*
FROM CreditCard as cc
RIGHT JOIN Payment p ON cc.cardNumber = p.creditcardNumber
RIGHT JOIN Orders o ON p.orderNumber = o.orderNumber;

#20. Retrieve all products and their associated store information (if available)
SELECT p.*, s.name AS storeName
FROM Product p
LEFT JOIN Store s ON p.sid = s.sid;

#21. Retrieve all addresses and the users associated with them (if available)
SELECT a.*, u.name AS userName
FROM Address a
LEFT JOIN Users u ON a.userid = u.userId;

#22. Retrieve all stores and their associated managers
SELECT s.*, u.name AS managerName
FROM Store s
LEFT JOIN Manage m ON s.sid = m.sid
LEFT JOIN Users u ON m.userid = u.userId;




