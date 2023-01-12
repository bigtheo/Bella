drop procedure if exists ps_JournalFacturationBoutqiue;
delimiter |
create procedure ps_JournalFacturationBoutqiue(IN p_date date)
BEGIN 
select i.id 'N° Facture',p.designation, c.name 'Client', i.created_time 'Date de facturation',d.amount 'Quantité',d.negociated_price 'Prix unitaire',d.amount*d.negociated_price 'Prix total' from invoices i 
INNER JOIN customers c on c.id = i.customer_id
inner join detailsfactureboutique d ON d.invoice_id = i.id
inner join products p on p.id = d.product_id where date(i.created_time) =date(p_date);

END |
DELIMITER ;
