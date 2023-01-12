drop view if exists v_facturation;
create view v_facturation as 
select i.id, i.created_time 'Date et heure',sum(d.negociated_price * amount) 'Prix total','Boutique' as 'Type' from invoices i 
INNER JOIN detailsfactureboutique d ON d.invoice_id = i.id 
WHERE date(i.created_time) = date(now()) group by(i.id)
UNION
select i.id, i.created_time 'Date et heure',sum(d.negociated_price * amount) 'Prix total','Pressing' as 'Type' from invoices i 
INNER JOIN detailsfacturepressing d ON d.invoice_id = i.id 
WHERE date(i.created_time) = date(now()) group by(i.id)

