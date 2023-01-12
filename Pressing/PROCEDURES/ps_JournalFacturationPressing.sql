drop procedure if exists ps_JournalFacturationPressing;
delimiter |
create procedure ps_JournalFacturationPressing(IN p_date date)
BEGIN 

select i.id 'N° Facture',t.designation, c.name 'Client', i.created_time 'Date de facturation',d.amount 'Quantité',d.negociated_price 'Prix unitaire', d.amount * d.negociated_price 'Prix total'  from invoices i 
INNER JOIN customers c on c.id = i.customer_id
inner join detailsfacturepressing d ON d.invoice_id = i.id
inner join tarifs t  on t.id = d.tarif_id where date(i.created_time) =date(p_date);

END |
DELIMITER ;