drop procedure if exists Ps_JournalCentralise;
delimiter |
CREATE DEFINER=`root`@`localhost` PROCEDURE `Ps_JournalCentralise`(IN p_date date)
BEGIN



DECLARE v_Total_Paiement_examen decimal default 0;
DECLARE v_Total_Paiement_examen_etat decimal default 0;
DECLARE v_Total_Paiement_frais_etat decimal default 0;
DECLARE v_Total_Paiement_manuel decimal default 0;
DECLARE v_Total_Paiement_frais_mensuel decimal default 0;
DECLARE v_Total_Paiement_frais_inscription decimal default 0;
DECLARE v_Total_Paiement_frais_DAP decimal default 0;
DECLARE v_Total_accompte decimal default 0;
DECLARE v_Total_general decimal default 0;
DECLARE v_Total_depense decimal default 0;
DECLARE v_Total_entree decimal default 0;




DECLARE   v_nombre_recu_inscription int  default 0;
DECLARE   v_nombre_recu_frais_mensuel int  default 0;
DECLARE   v_nombre_recu_examen_etat int  default 0;
DECLARE   v_nombre_recu_Paiement_manuel int  default 0;
DECLARE   v_nombre_recu_Paiement_examen int  default 0;
DECLARE   v_nombre_recu_Paiement_frais_etat int  default 0;
DECLARE	  v_nombre_recu_DAP int default 0;
DECLARE	  v_nombre_total_recu int default 0;
DECLARE   v_nombre_total_accompte int default 0;




frais_examen:BEGIN
	SELECT sum(cfe.montant) INTO v_Total_Paiement_examen
		FROM PAIEMENT_EXAMEN as pe 
			INNER JOIN eleve as e ON pe.eleve_id=e.id
			INNER JOIN frais_examen as fe ON pe.frais_examen_id=fe.id 
			INNER JOIN classe AS c On e.classe_id=c.id
            INNER JOIN classe_frais_examen as cfe ON cfe.classe_id=c.id AND cfe.frais_examen_id=fe.id
		WHERE date( pe.date_paie)=p_date;
        
        SELECT count(*) INTO v_nombre_recu_Paiement_examen
		FROM PAIEMENT_EXAMEN as pe 
			INNER JOIN eleve as e ON pe.eleve_id=e.id
			INNER JOIN frais_examen as fe ON pe.frais_examen_id=fe.id 
			INNER JOIN classe AS c On e.classe_id=c.id
            INNER JOIN classe_frais_examen as cfe ON cfe.classe_id=c.id AND cfe.frais_examen_id=fe.id
		WHERE date( pe.date_paie)=p_date;
END;
frais_frais_etat:BEGIN
	select
	SUM(cfe.montant) INTO v_Total_Paiement_frais_etat
	from paiement_etat as pe
		INNER JOIN eleve as e On pe.eleve_id=e.id
		INNER JOIN classe as c ON e.classe_id=c.id
		INNER JOIN frais_etat as fe ON pe.frais_etat_id=fe.id
        INNER JOIN classe_frais_etat as cfe ON cfe.classe_id=c.id AND cfe.frais_etat_id=fe.id
	WHERE date(pe.date_paie)=p_date;
    
    	select
	count(*) INTO v_nombre_recu_Paiement_frais_etat
	from paiement_etat as pe
		INNER JOIN eleve as e On pe.eleve_id=e.id
		INNER JOIN classe as c ON e.classe_id=c.id
		INNER JOIN frais_etat as fe ON pe.frais_etat_id=fe.id
        INNER JOIN classe_frais_etat as cfe ON cfe.classe_id=c.id AND cfe.frais_etat_id=fe.id
	WHERE date(pe.date_paie)=p_date;
    
END;

frais_manuel:BEGIN
select 
	SUM(pm.quantite* m.prix_unitaire) INTO v_Total_Paiement_manuel
	from paiement_manuels as pm
	INNER JOIN eleve AS e ON pm.eleve_id=e.id
	INNER JOIN CLASSE AS c ON e.classe_id=c.id
	INNER JOIN manuels AS m ON pm.manuel_id=m.id
WHERE date(pm.date_paie)=p_date;

select 
	count(*) INTO v_nombre_recu_Paiement_manuel
	from paiement_manuels as pm
	INNER JOIN eleve AS e ON pm.eleve_id=e.id
	INNER JOIN CLASSE AS c ON e.classe_id=c.id
	INNER JOIN manuels AS m ON pm.manuel_id=m.id
WHERE date(pm.date_paie)=p_date;


END;

frais_mansuel:BEGIN
	select sum(f.Montant) INTO v_Total_Paiement_frais_mensuel
		from paiement_mensuel as pm
		INNER JOIN  eleve as e ON pm.eleve_id=e.id
		INNER JOIN frais_mensuel as f ON pm.frais_mensuel_id=f.id
		INNER JOIN classe as c ON e.classe_id=c.id
	WHERE date(pm.date_paie) =date(p_date) and f.designation!='Inscription'  AND 
    pm.frais_mensuel_id NOT IN (
		SELECT  a.frais_mensuel_id 
		from accompte a where  a.frais_mensuel_id=pm.frais_mensuel_id 
		and a.eleve_id=e.id 
		and date(a.date_paie)=date(p_date)
    );
    
    
    select count(*) INTO v_nombre_recu_frais_mensuel
		from paiement_mensuel as pm
		INNER JOIN  eleve as e ON pm.eleve_id=e.id
		INNER JOIN frais_mensuel as f ON pm.frais_mensuel_id=f.id
		INNER JOIN classe as c ON e.classe_id=c.id
	WHERE date(pm.date_paie) = p_date and f.designation!='Inscription';
END;
frais_inscription:BEGIN
select sum(f.Montant) INTO v_Total_Paiement_frais_inscription
		from paiement_mensuel as pm
		INNER JOIN  eleve as e ON pm.eleve_id=e.id
		INNER JOIN frais_mensuel as f ON pm.frais_mensuel_id=f.id
		INNER JOIN classe as c ON e.classe_id=c.id
	WHERE f.designation='Inscription' AND date(pm.date_paie) = p_date ;
    
    
    select count(*) INTO v_nombre_recu_inscription
		from paiement_mensuel as pm
		INNER JOIN  eleve as e ON pm.eleve_id=e.id
		INNER JOIN frais_mensuel as f ON pm.frais_mensuel_id=f.id
		INNER JOIN classe as c ON e.classe_id=c.id
	WHERE f.designation='Inscription' AND date(pm.date_paie) = p_date ;
END;

frais_exetat:BEGIN
	select sum(cf.montant) INTO v_Total_Paiement_examen_etat
		from paiement_exetat as pe
		INNER JOIN eleve as e ON pe.eleve_id=e.id
		INNER JOIN classe as c on e.classe_id=c.id
		INNER JOIN frais_exetat as fe ON pe.frais_exetat_id=fe.id
		INNER JOIN classe_frais_exetat cf on cf.frais_exetat_id=fe.id AND cf.classe_id=c.id
	where date(pe.date_paie)=p_date;
    
    
    select count(*) INTO v_nombre_recu_examen_etat
		from paiement_exetat as pe
		INNER JOIN eleve as e ON pe.eleve_id=e.id
		INNER JOIN classe as c on e.classe_id=c.id
		INNER JOIN frais_exetat as fe ON pe.frais_exetat_id=fe.id
		INNER JOIN classe_frais_exetat cf on cf.frais_exetat_id=fe.id AND cf.classe_id=c.id
	where date(pe.date_paie)=p_date;
END;


accompte : begin
select count(id) INTO v_nombre_total_accompte from accompte where date(date_paie) = date(p_date);
select sum(montant) INTO v_Total_accompte from accompte where date(date_paie)=date(p_date);
end;

calcul_total_depenses:begin

SELECT -ifnull(sum(montant),0) into v_Total_depense from depenses where date(created_time) = date(p_date);

end;
affichage:BEGIN

 DECLARE v_Total_general  decimal default 0;
 
 IF v_Total_Paiement_frais_mensuel IS NULL THEN
	SET v_Total_Paiement_frais_mensuel = 0;
 END IF;
 IF v_Total_Paiement_frais_etat IS NULL THEN
	SET v_Total_Paiement_frais_etat = 0;
 END IF;
 IF v_Total_Paiement_examen IS NULL THEN
	SET v_Total_Paiement_examen = 0;
 END IF;
 IF v_Total_Paiement_examen_etat IS NULL THEN
	SET v_Total_Paiement_examen_etat = 0;
 END IF;
 IF v_Total_Paiement_manuel IS NULL THEN
	SET v_Total_Paiement_manuel = 0;
 END IF;
 IF v_Total_Paiement_frais_inscription IS NULL THEN
	SET v_Total_Paiement_frais_inscription = 0;
 END IF;
 

 
 IF v_Total_accompte IS NULL THEN 
	SET v_Total_accompte :=0;
 END IF;
 


  
 
 


 
 nombre_de_recu:begin
 
 end;
 SET v_Total_general = v_Total_Paiement_frais_mensuel + v_Total_Paiement_frais_inscription + v_Total_Paiement_frais_etat + v_Total_Paiement_examen + v_Total_Paiement_examen_etat + v_Total_Paiement_manuel+v_Total_accompte+ v_Total_depense;
 SET v_nombre_total_recu = v_nombre_recu_inscription + v_nombre_recu_DAP +v_nombre_recu_Paiement_examen+ v_nombre_recu_frais_mensuel +v_nombre_recu_Paiement_frais_etat+ v_nombre_recu_Paiement_manuel + v_nombre_recu_Paiement_examen + v_nombre_recu_examen_etat + v_nombre_total_accompte;
 Set v_Total_entree = v_Total_Paiement_frais_mensuel + v_Total_Paiement_frais_inscription + v_Total_Paiement_frais_etat + v_Total_Paiement_examen + v_Total_Paiement_examen_etat + v_Total_Paiement_manuel+v_Total_accompte;
        SELECT 0 AS 'N°','Frais Inscription' AS 'Intitulé frais',v_nombre_recu_inscription as 'Nombre de Reçu',v_Total_Paiement_frais_inscription as Total
        UNION
		SELECT 1 AS 'N°','Frais mensuel' AS 'Intitulé frais',v_nombre_recu_frais_mensuel as 'Nombre de Reçu',v_Total_Paiement_frais_mensuel as Total
        UNION
		SELECT 2,'Frais de l''état' AS'Intitulé frais',v_nombre_recu_Paiement_frais_etat as 'Nombre de Reçu',v_Total_Paiement_frais_etat as Total
        UNION
		SELECT 3,'Frais frais d''examen' AS 'Intitulé frais',v_nombre_recu_Paiement_examen as 'Nombre de Reçu' ,v_Total_Paiement_examen as Total
        UNION
		SELECT 4,'Frais examen d''état' AS 'Intitulé frais',v_nombre_recu_examen_etat as 'Nombre de Reçu',v_Total_Paiement_examen_etat as Total
        UNION
		SELECT 5,'vente des manuels' AS 'Intitulé frais',v_nombre_recu_Paiement_manuel as  'Nombre de Reçu',v_Total_Paiement_manuel as Total
        UNION
        SELECT 7,'Accompte' AS 'Intitulé frais',v_nombre_total_accompte as  'Nombre de Reçu', v_Total_accompte as Total
        UNION
        SELECT 8, 'Total entrée','--',v_Total_entree as Total
        UNION
        SELECT  8,'Dépenses journalières', count(*),-sum(montant) from depenses where date(created_time)=date(p_date) 
        UNION
        SELECT 9,'TOTAL' AS 'Intitulé frais',v_nombre_total_recu as 'Nombre de Reçu',v_Total_general as Total;

END;
END |

delimiter ;