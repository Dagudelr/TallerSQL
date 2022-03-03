CREATE DATABASE IF NOT EXISTS store;

USE store;

CREATE TABLE IF NOT EXISTS supplier(
    sup_id INT PRIMARY KEY AUTO_INCREMENT,
    sup_name VARCHAR(80) NOT NULL,
    sup_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sup_delete_at TIMESTAMP NULL,
    sup_updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS product(
    pro_id INT PRIMARY KEY AUTO_INCREMENT,
    sup_id INT NOT NULL,
    pro_name VARCHAR(80) NOT NULL,
    pro_brand VARCHAR(80) NOT NULL,
    pro_price INT UNSIGNED NOT NULL,
    pro_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pro_delete_at TIMESTAMP NULL,
    pro_updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX fk_product_supplier_idx (sup_id ASC) VISIBLE,
    UNIQUE INDEX product_name_UNIQUE (pro_name ASC, pro_brand ASC, sup_id ASC) VISIBLE,
    CONSTRAINT fk_product_supplier
     FOREIGN KEY (sup_id)
     REFERENCES store.supplier (sup_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS document_type(
    dot_id INT PRIMARY KEY AUTO_INCREMENT,
    dot_name VARCHAR(30) NOT NULL,
    dot_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dot_delete_at TIMESTAMP NULL,
    dot_updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS customer(
    cus_id INT PRIMARY KEY AUTO_INCREMENT,
    dot_id INT NOT NULL,
    cus_document_number VARCHAR(11) NOT NULL,
    cus_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cus_delete_at TIMESTAMP NULL,
    cus_updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX fk_customer_dot_idx (dot_id ASC) VISIBLE,
    UNIQUE INDEX cus_document_number_UNIQUE (cus_document_number ASC, dot_id ASC) VISIBLE,
    CONSTRAINT fk_customer_document_type
     FOREIGN KEY (dot_id)
     REFERENCES store.document_type (dot_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS salesman(
    sal_id INT PRIMARY KEY AUTO_INCREMENT,
    sal_name VARCHAR(80) NOT NULL,
    sal_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sal_delete_at TIMESTAMP NULL,
    sal_updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS invoice(
    inv_id INT PRIMARY KEY AUTO_INCREMENT,
    sal_id INT NOT NULL,
    cus_id INT NOT NULL,
    inv_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    inv_delete_at TIMESTAMP NULL,
    inv_updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX fk_invoice_salesman_idx (sal_id ASC) VISIBLE,
    INDEX fk_invoice_customer_idx (cus_id ASC) VISIBLE,
    CONSTRAINT fk_invoice_salesman
    FOREIGN KEY (sal_id)
     REFERENCES store.salesman (sal_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE,
    CONSTRAINT fk_invoice_customer
     FOREIGN KEY (cus_id)
     REFERENCES store.customer (cus_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS order_invoice_product(
	oip_id INT PRIMARY KEY AUTO_INCREMENT,	
    inv_id INT NOT NULL,
    pro_id INT NOT NULL,
	INDEX inv_pro_idx_uniq (inv_id ASC, pro_id ASC) VISIBLE,
    CONSTRAINT fk_order_invoice
     FOREIGN KEY (inv_id)
     REFERENCES store.invoice (inv_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE,
    CONSTRAINT fk_order_product
     FOREIGN KEY (pro_id)
     REFERENCES store.product (pro_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
) ENGINE = InnoDB;

INSERT INTO supplier(sup_name) VALUES
    ('Femsa'),
    ('Postobon'),
    ('Bimbo'),
    ('Pepsico');
    
INSERT INTO product(sup_id, pro_name, pro_brand, pro_price) VALUES
	(1, 'Coca-cola x300ml', 'Coca-Cola Company', 2500),
	(1, 'Coca-cola x1.5l', 'Coca-Cola Company', 4300),
	(2, 'Pepsi x1.5l', 'Pepsi', 3900),
	(2, 'Colombiana x300ml', 'Postobon', 2300),
	(3, 'Chocoso x65g', 'Bimbo', 1500),
	(3, 'Brownie Arequipe x75g', 'Bimbo', 2600),
	(4, 'Papas natural x130g', 'Margarita', 4500),
	(4, 'Papas limon x130g', 'Margarita', 4500);

INSERT INTO document_type(dot_name) VALUES
    ('CC'),
    ('TI'),
    ('CE'),
    ('NIT'),
    ('PAP');
    
INSERT INTO salesman(sal_name) VALUES 
	('Daniel Agudelo');

INSERT INTO customer(dot_id, cus_document_number) VALUES
    (1, '115271302'),
	(1, '125463214'),
    (2, '125421421'),
    (1, '125421322'),
    (1, '125421525'),
    (1, '125421324'),
    (1, '125421529');
    
INSERT INTO invoice(sal_id, cus_id) VALUES
    (1,1),
    (1,2),
    (1,3),
    (1,4),
    (1,5),
    (1,6),
    (1,7);

INSERT INTO order_invoice_product(inv_id, pro_id) VALUES
    (1, 2),(1, 2),(1, 6),(1, 7),(1, 8),
	(2, 2),(2, 2),(2, 6),(2, 7),(2, 8),
	(3, 1),(3, 2),(3, 6),(3, 5),(3, 4),
    (4, 2),(4, 5),(4, 3),(4, 1),(4, 7),
    (5, 8),(5, 7),(5, 1),(5, 1),(5, 2),
    (4, 2),(4, 5),(4, 3),(4, 1),(4, 7),
    (5, 8),(5, 7),(5, 1),(5, 1),(5, 2);

-- Borrado lógico de factura
UPDATE invoice 
SET inv_delete_at = NOW()
WHERE inv_id = 4;

UPDATE invoice 
SET inv_delete_at = NOW()
WHERE inv_id =5;

-- Borrado físico
DELETE 
FROM invoice
WHERE inv_id = 6;

DELETE 
FROM invoice
WHERE inv_id = 7;

-- Actualización del nombre de 3 productos y su proveedor

UPDATE product
SET sup_id = 4, pro_name = 'De Todito Natural x150g', pro_brand = 'Margarita', pro_price = 5500
WHERE pro_id = 3;

UPDATE product
SET sup_id = 3, pro_name = 'Pan integral x650g', pro_brand = 'Bimbo', pro_price = 7800
WHERE pro_id = 4;

UPDATE product
SET sup_id = 1, pro_name = 'Powerade x500g', pro_brand = 'Coca-Cola Company', pro_price = 2300
WHERE pro_id = 6;

SELECT *FROM customer;