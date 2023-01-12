
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
DECLARE v_Total_autres_paiement decimal default 0;


frais_examen:BEGIN
	SELECT sum(cfe.montant) INTO v_Total_Paiement_examen
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
END;

frais_manuel:BEGIN
select 
	SUM(pm.quantite* m.prix_unitaire) INTO v_Total_Paiement_manuel
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
	WHERE date(pm.date_paie) = p_date and f.designation!='Inscription';
END;
frais_inscription:BEGIN
select sum(f.Montant) INTO v_Total_Paiement_frais_inscription
		from paiement_mensuel as pm
		INNER JOIN  eleve as e ON pm.eleve_id=e.id
		INNER JOIN frais_mensuel as f ON pm.frais_mensuel_id=f.id
		INNER JOIN classe as c ON e.classe_id=c.id
	WHERE f.designation='Inscription' AND date(pm.date_paie) = p_date ;
END;

frais_autres_paiement:BEGIN
		select sum(f.Montant) INTO v_Total_autres_paiement
		from autres_paiements as pm
		INNER JOIN  eleve as e ON pm.eleve_id=e.id
		INNER JOIN autres_frais as f ON pm.frais_id=f.id
		INNER JOIN classe as c ON e.classe_id=c.id
	WHERE date(pm.date_paie) = p_date ;
END;


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
	SET v_Total_Paiement_frais_inscription= 0;
 END IF;
 
 SET v_Total_general = v_Total_Paiement_frais_inscription + v_Total_Paiement_frais_mensuel  + v_Total_autres_paiement +  v_Total_Paiement_manuel;

		SELECT 0 AS 'N°','Frais Inscription' AS 'Intitulé frais',v_Total_Paiement_frais_inscription as Total
        UNION
		SELECT 1 AS 'N°','Frais mensuel' AS 'Intitulé frais',v_Total_Paiement_frais_mensuel as Total
        UNION
		SELECT 2,'Autres Paiements' AS'Intitulé frais',v_Total_autres_paiement as Total
        UNION
        SELECT 3,'TOTAL' AS 'Intitulé frais',v_Total_general as Total;

END;
END |

delimiter ;