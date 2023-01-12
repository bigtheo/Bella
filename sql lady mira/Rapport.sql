drop procedure if exists ps_journal_echeance;
delimiter |
CREATE  PROCEDURE `ps_journal_echeance`(in p_date_debut date,in p_date_fin date,IN p_index int)
BEGIN
declare v_total_pressing decimal default 0;

-- affichage des factures
IF p_index = 0 THEN 
	select i.id 'Facture',c.Name, c.phone,DATE(i.created_time) 'Date', sum(d.amount * d.negociated_price) Montant, i.IsPayed 'Est payée?' 
	from customers c 
	inner join invoices i on i.customer_id = c.id 
	inner join detailsfacturepressing d on d.invoice_id = i.id where date(i.created_time) between p_date_debut and p_date_fin 
	group by  i.id;
END IF;

-- detaitls des factures
IF p_index = 1 THEN 

select i.id 'Fature',c.name, c.phone,date(d.created_time) 'Date', t.designation,t.unity_price 'PU', d.amount 'QT',(d.negociated_price * d.amount) 'PT' from invoices i 
inner join detailsfacturepressing d on d.invoice_id = i.id 
inner join customers c on c.id = i.customer_id
inner join tarifs t on t.id = d.tarif_id  where date(i.created_time) between p_date_debut and p_date_fin ;

END IF;

IF p_index = 2 THEN 

select i.id 'Facture', c.name, c.phone,sum(d.negociated_price * d.amount) 'Total à payer',a.montant 'Montant Payé',sum(d.negociated_price * d.amount) - a.montant 'Reste à payer' from
detailsfacturepressing d
inner join invoices i on i.id = d.invoice_id
inner join accompte a on a.invoice_id = i.id
inner join customers c on c.id = i.customer_id where date(i.created_time) between p_date_debut and p_date_fin and i.IsPayed=false

group by i.id;

END IF; 




END |