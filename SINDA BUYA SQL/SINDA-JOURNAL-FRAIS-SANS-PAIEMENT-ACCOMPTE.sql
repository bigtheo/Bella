drop  procedure if  exists PS_JournalDesFrais;
delimiter |
CREATE  PROCEDURE `PS_JournalDesFrais`(IN p_index_frais tinyint,IN p_date date)
BEGIN
	CASE p_index_frais
		WHEN 0 THEN 
        
			frais_mensuel :BEGIN  
            SELECT  
				p.id as 'N°',time(p.date_paie) as Heure,e.id ,concat_ws(' ',e.nom,e.postnom,e.prenom) as Noms,c.nom as Classe,f.designation,f.Montant as Montant
				FROM paiement_mensuel as p 
					INNER JOIN eleve as e on p.eleve_id=e.id
					INNER JOIN  classe as c ON e.classe_id=c.id
					INNER JOIN frais_mensuel as f ON p.frais_mensuel_id=f.id 
                    WHERE date(p.date_paie) = p_date and  p.paye = true
					UNION
                    SELECT '-' as 'N°','-' as Heure,'-' as Noms,'-'as Classe,'-','TOTAL' as designation ,sum( f.Montant) as Montant
				FROM paiement_mensuel as p 
					INNER JOIN eleve as e on p.eleve_id=e.id
					INNER JOIN  classe as c ON e.classe_id=c.id
					INNER JOIN frais_mensuel as f ON p.frais_mensuel_id=f.id
				WHERE date(p.date_paie) = p_date and  p.paye = true;
            END;
            
        WHEN 1 THEN   
			frais_examen:BEGIN
            SELECT  
					p.id as 'N°',time(p.date_paie) as Heure,e.id ,concat_ws(' ',e.nom,e.postnom,e.prenom) as Noms,c.nom as Classe,f.designation,cf.Montant
					FROM paiement_examen as p 
					INNER JOIN eleve as e on p.eleve_id=e.id
					INNER JOIN  classe as c ON e.classe_id=c.id
					INNER JOIN frais_examen as f ON p.frais_examen_id=f.id
					INNER JOIN classe_frais_examen as cf ON cf.classe_id=c.id And P.frais_examen_id=cf.frais_examen_id
					WHERE date(p.date_paie) = p_date 
                    UNION
					SELECT '-' as 'N°','-' as Heure,'-' as Noms,'-'as Classe,'-','TOTAL' as designation ,sum( cf.Montant) as Montant
					FROM paiement_examen as p 
					INNER JOIN eleve as e on p.eleve_id=e.id
					INNER JOIN  classe as c ON e.classe_id=c.id
					INNER JOIN frais_examen as f ON p.frais_examen_id=f.id
					INNER JOIN classe_frais_examen as cf ON cf.classe_id=c.id And P.frais_examen_id=cf.frais_examen_id
					WHERE date(p.date_paie) = p_date ;
            END;
		WHEN 2 THEN  
			frais_etat:BEGIN
            
            SELECT  
					p.id as 'N°',time(p.date_paie) as Heure,e.id ,concat_ws(' ',e.nom,e.postnom,e.prenom) as Noms,c.nom as Classe,f.designation,cf.Montant
					FROM paiement_exetat as p 
					INNER JOIN eleve as e on p.eleve_id=e.id
					INNER JOIN  classe as c ON e.classe_id=c.id
					INNER JOIN frais_exetat as f ON p.frais_exetat_id=f.id
					INNER JOIN classe_frais_exetat as cf ON cf.classe_id=c.id And P.frais_exetat_id=cf.frais_exetat_id
					WHERE date(p.date_paie) =p_date; 
            END;
		WHEN 3 THEN   
			SELECT  
					p.id as 'N°',time(p.date_paie) as Heure,e.id ,concat_ws(' ',e.nom,e.postnom,e.prenom) as Noms,c.nom as Classe,
					m.intitule as 'Intitulé',m.prix_unitaire as 'Prix Unitaire',p.quantite as 'Quantité',
					p.quantite*m.prix_unitaire as 'Prix Total'
					FROM paiement_manuels as p 
					INNER JOIN eleve as e on p.eleve_id=e.id
					INNER JOIN  classe as c ON e.classe_id=c.id
					INNER JOIN manuels as m ON p.manuel_id=m.id
					WHERE date(p.date_paie) = p_date;
		WHEN 4 THEN   
        frais_etat: BEGIN
        
			SELECT 
					p.id as 'N°',time(p.date_paie) as Heure,e.id ,concat_ws(' ',e.nom,e.postnom,e.prenom) as Noms,c.nom Classe,f.designation ,cf.Montant
					FROM paiement_etat as p 
					INNER JOIN eleve as e on p.eleve_id=e.id
					INNER JOIN  classe as c ON e.classe_id=c.id
					INNER JOIN frais_etat as f ON p.frais_etat_id=f.id
					INNER JOIN classe_frais_etat as cf ON cf.classe_id=c.id And P.frais_etat_id=cf.frais_etat_id
					WHERE date(p.date_paie) = p_date;
				END;
        ELSE
			SELECT 'vueillez selectionner le frais s''il vous plait !!!! ' as message;
        END CASE ;
END |