drop procedure if exists ps_journal_echeance;
delimiter |
create  procedure ps_journal_echeance(in p_date_debut date,in p_date_fin date)
BEGIN
declare v_total_pressing decimal default 0;


select i.id 'Facture',c.Name, c.phone,i.created_time 'Date', sum(d.amount * d.negociated_price) Montant, i.IsPayed 'Est payée?' from customers c 
inner join invoices i on i.customer_id = c.id 
inner join detailsfacturepressing d on d.invoice_id = i.id where date(i.created_time) between p_date_debut and p_date_fin 
group by  i.id;

END |

delimiter ;