USE store;

-- Factura con cada producto y precio de cada uno digitando el numero de documento y el tipo de documento
SELECT product.pro_price as precio, product.pro_name as product_name, invoice.inv_id as invoice_id, order_invoice_product.oip_id as order_id, invoice.inv_delete_at
FROM ((order_invoice_product 
INNER JOIN product ON order_invoice_product.pro_id = product.pro_id)
INNER JOIN invoice ON order_invoice_product.inv_id = invoice.inv_id)
WHERE invoice.cus_id = 
(SELECT customer.cus_id
FROM customer
WHERE customer.cus_document_number = '125421421'
AND customer.dot_id = 2
AND customer.cus_delete_at IS NULL)
AND invoice.inv_delete_at IS NULL;

-- Factura con total digitando el numero de documento y el tipo de documento
SELECT invoice.inv_id as invoice_id, invoice.cus_id, SUM(product.pro_price) as precio_total, invoice.inv_delete_at
FROM ((order_invoice_product 
INNER JOIN product ON order_invoice_product.pro_id = product.pro_id)
INNER JOIN invoice ON order_invoice_product.inv_id = invoice.inv_id)
WHERE order_invoice_product.inv_id = 
(SELECT customer.cus_id
FROM customer
WHERE customer.cus_document_number = '115271302'
AND customer.dot_id = 1
AND customer.cus_delete_at IS NULL) 
AND invoice.inv_delete_at IS NULL;

-- Consulta por nombre de producto que obtiene el nombre del proveedor

SELECT supplier.sup_name
FROM supplier
WHERE supplier.sup_id = 
(SELECT product.sup_id
FROM product
WHERE product.pro_name = 'Coca-cola x1.5l'
 AND product.pro_delete_at IS NULL)
AND supplier.sup_delete_at IS NULL;

-- (PLUS) producto con más ventas (Está información viene de la orden y no de la factura)
SELECT order_invoice_product.pro_id, COUNT(order_invoice_product.pro_id) AS cantidad_vendida
FROM order_invoice_product
GROUP BY order_invoice_product.pro_id
HAVING COUNT(cantidad_vendida)
ORDER BY cantidad_vendida DESC