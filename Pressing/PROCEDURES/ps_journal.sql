drop procedure if exists ps_journal;
delimiter |
create  procedure ps_journal(in p_date date)
BEGIN
declare v_total_pressing decimal default 0;
declare v_total_boutique decimal default 0;
declare v_total_depense decimal default 0;
declare v_solde decimal default 0;

-- total boutique
select ifnull(sum(negociated_price*amount),0) into v_total_boutique from detailsfactureboutique where date(created_time)= date(p_date);

-- total pressing 

select ifnull(sum(negociated_price*amount),0) into v_total_pressing from detailsfacturepressing where date(created_time)= date(p_date);

-- total depense 
Select ifnull(sum(montant),0) into v_total_depense from depenses where date(created_time) = date(p_date);


-- calcul du solde 

set v_solde := (v_total_boutique + v_total_pressing) - v_total_depense;

select '01' AS 'N°','Total Vente' as 'Désignation',ifnull(sum(negociated_price*amount),0) 'Montant' from detailsfactureboutique where date(created_time)= date(p_date)
UNION 
select '02' AS 'N°','Total Pressing' as 'Désignation',ifnull(sum(negociated_price*amount),0) 'Montant' from detailsfacturepressing where date(created_time)= date(p_date)
UNION 
Select '03' AS 'N°','Totale Dépense' as 'Désignation',ifnull(sum(montant),0) from depenses where date(created_time) = date(p_date)
UNION 
select '-','Solde',v_solde;

END |

delimiter ;