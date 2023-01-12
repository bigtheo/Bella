drop procedure if exists ps_JournalRetrait;

delimiter |
create procedure ps_JournalRetrait(in p_date date)
begin

select i.id 'N° Facture',c.name 'client',if(r.created_time is not null,'rétiré','non rétiré') statut,sum(d.negociated_price) 'Montant' from invoices i
left join retrait r on r.invoice_id = i.id
inner join detailsfacturepressing d on d.invoice_id = i.id
inner join customers c on c.id = i.customer_id
where date(i.created_time)=date(p_date)
group by i.id ;

end |