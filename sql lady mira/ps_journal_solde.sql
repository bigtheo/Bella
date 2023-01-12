drop procedure if exists ps_journal_solde;
delimiter |
CREATE  PROCEDURE `ps_journal_solde`(in p_date_debut date,in p_date_fin date, OUT p_montant_a_payer decimal,OUT p_montant_paye decimal, out p_reste_a_payer decimal)
BEGIN

-- montant à payer 	
	select ifnull(sum(amount * negociated_price),0) INTO p_montant_a_payer  from detailsfacturepressing  where date(created_time) between p_date_debut and p_date_fin ;
    
-- Montant payé 
	SELECT ifnull(sum(montant),0) INTO p_montant_paye from accompte  where date(created_time) between p_date_debut and p_date_fin ;
    
-- Reste à payer 

 set p_reste_a_payer = p_montant_a_payer - p_montant_paye;

END |

delimiter ;