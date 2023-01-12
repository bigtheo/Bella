drop procedure if exists ps_journal_echeance;
delimiter |
create  procedure ps_journal_echeance(in p_date_debut date,in p_date_fin date)
BEGIN
declare v_total_pressing decimal default 0;
declare v_total_boutique decimal default 0;
declare v_total_depense decimal default 0;
declare v_solde decimal default 0;

-- total boutique
select ifnull(sum(negociated_price*amount),0) into v_total_boutique from detailsfactureboutique where date(created_time)  between p_date_debut and p_date_fin;

-- total pressing 

select ifnull(sum(negociated_price*amount),0) into v_total_pressing from detailsfacturepressing where date(created_time) between p_date_debut and p_date_fin;

-- total depense 
Select ifnull(sum(montant),0) into v_total_depense from depenses where date(created_time)  between p_date_debut and p_date_fin;


-- calcul du solde 

set v_solde := (v_total_boutique + v_total_pressing) - v_total_depense;

select '01' AS 'N°','Total Vente' as 'Désignation',ifnull(sum(negociated_price*amount),0) 'Montant' from detailsfactureboutique where date(created_time) between p_date_debut and p_date_fin
UNION 
select '02' AS 'N°','Total Pressing' as 'Désignation',ifnull(sum(negociated_price*amount),0) 'Montant' from detailsfacturepressing where date(created_time) between p_date_debut and p_date_fin
UNION 
Select '03' AS 'N°','Totale Dépense' as 'Désignation',ifnull(sum(montant),0) from depenses where date(created_time) between p_date_debut and p_date_fin
UNION 
select '-','Solde',v_solde;

END |

delimiter ;