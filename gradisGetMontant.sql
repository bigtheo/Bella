DROP PROCEDURE IF EXISTS `Ps_obtenirMoisApayer`;
DELIMITER |
CREATE PROCEDURE `Ps_obtenirMoisApayer`(IN p_eleve_id smallint, OUT p_moisApayer VARCHAR(20) )
BEGIN

 DECLARE v_nombrePaiementMensuel INT default 0;
 DECLARE v_moisInscription INT default 0;
 DECLARE v_jourInscription INT default 0;
 DECLARE v_dernierMoisPaye varchar(20) ;
 DECLARE v_jourCondition smallint unsigned ;
 DECLARE v_moisApayer varchar(30) default '0';
 
 

 
 select count(id) INTO v_nombrePaiementMensuel from paiement_mensuel where eleve_id=p_eleve_id;
 
 
 SELECT month(p.date_paie) INTO v_moisInscription from paiement_mensuel as p INNER JOIN frais_mensuel as f 
   ON f.id=p.frais_mensuel_id 
   WHERE eleve_id=p_eleve_id and f.designation='Inscription';
 
 
 SELECT day(p.date_paie) INTO v_jourInscription from paiement_mensuel as p INNER JOIN frais_mensuel as f 
   ON f.id=p.frais_mensuel_id 
   WHERE eleve_id=p_eleve_id and f.designation='Inscription';
   
   
   SELECT f.designation INTO v_dernierMoisPaye from paiement_mensuel as p 
   INNER JOIN frais_mensuel as f ON f.id=p.frais_mensuel_id 
   WHERE eleve_id=p_eleve_id order by p.id   desc limit 1 ;
   
   
   SELECT jour_mois_condition INTO v_jourCondition from configuration limit 1;
   
 
 IF v_nombrePaiementMensuel = 1 THEN 
	IF v_moisInscription < 9 THEN 
			SET v_moisApayer ='septembre';
		END IF;
	IF v_moisInscription = 9 THEN 
             IF v_jourInscription <= v_jourCondition THEN
			   SET v_moisApayer ='septembre';
            ELSE
            SET v_moisApayer ='octobre';
		END IF;
        END IF;
        ELSE
			IF v_moisInscription <= 10 THEN 
				IF v_jourInscription < v_jourCondition THEN
					SET v_moisApayer = 'octobre';
                    ELSE
                    SET v_moisApayer = 'novembre';
				END IF;
			ELSE
            IF v_moisInscription = 11 THEN 
				IF v_jourInscription < v_jourCondition THEN
					SET v_moisApayer = 'novembre';
                    ELSE
                    SET v_moisApayer = 'décembre';
				END IF;
			ELSE 
                IF v_moisInscription = 12 THEN 
					IF v_jourInscription < v_jourCondition THEN
						SET v_moisApayer = 'décembre';
						ELSE
						SET v_moisApayer = 'janvier';
					END IF;
                ELSE 
                IF v_moisInscription = 1 THEN 
					IF v_jourInscription < v_jourCondition THEN
							SET v_moisApayer = 'janvier';
							ELSE
							SET v_moisApayer = 'février';
						END IF;
                ELSE
					IF v_moisInscription = 2 THEN
						IF v_jourInscription < v_jourCondition THEN
							SET v_moisApayer = 'février';
							ELSE
							SET v_moisApayer = 'Mars';
						END IF;
					ELSE
                     IF v_moisInscription = 3 THEN 
						IF v_jourInscription < v_jourCondition THEN
							SET v_moisApayer = 'mars';
							ELSE
							SET v_moisApayer = 'avril';
						END IF;
					ELSE
                    IF v_moisInscription = 4 THEN 
                    IF v_jourInscription < v_jourCondition THEN
							SET v_moisApayer = 'avril';
							ELSE
							SET v_moisApayer = 'mai';
						END IF;
					ELSE 
                      IF v_moisInscription = 5 THEN
                      IF v_jourInscription < v_jourCondition THEN
							SET v_moisApayer = 'mai';
							ELSE
							SET v_moisApayer = 'juin';
						END IF;
                   ELSE 
                   IF v_moisInscription = 6 THEN

							SET v_moisApayer = 'septembre';

					ELSE  
                     IF v_moisInscription = 7 THEN 
						
								SET v_moisApayer = 'septembre';
					ELSE 
                    IF v_moisInscription = 8 THEN 
                    
								SET v_moisApayer = 'septembre';
						
                   END IF;
			END IF;
		    END IF;
            END IF;
			END IF;
			END IF;
			END IF;
            END IF;
            END IF;
            END IF;
            END IF;
            END IF ;

IF v_dernierMoisPaye = 'septembre' THEN
		SET v_moisApayer = 'octobre';
END IF;
     
IF v_dernierMoisPaye = 'Octobre' THEN
	SET v_moisApayer = 'novembre';
END IF;
     
IF v_dernierMoisPaye = 'novembre' THEN 
	SET v_moisApayer = 'décembre';
end if;
     
IF v_dernierMoisPaye = 'Décembre' THEN 
	SET  v_moisApayer = 'Janvier';
end if;
        
IF v_dernierMoisPaye = 'Janvier' THEN 
		SET  v_moisApayer = 'Février';
end if;
        
IF v_dernierMoisPaye = 'février' THEN 
		SET  v_moisApayer = 'mars';
	END IF ;

IF v_dernierMoisPaye = 'mars' THEN 
			SET  v_moisApayer = 'avril';
END IF;

IF v_dernierMoisPaye = 'Avril' THEN 
			SET  v_moisApayer = 'Mai';
END IF;

IF v_dernierMoisPaye = 'mai' THEN 
			SET  v_moisApayer = 'Juin';
END IF;

IF v_dernierMoisPaye = 'juin' THEN 
			SET  v_moisApayer = 'juillet';
END IF;

IF v_dernierMoisPaye = 'juillet' THEN 
			SET  v_moisApayer = 'aout';
END IF;

 IF v_dernierMoisPaye = 'aout' THEN 
			SET  v_moisApayer = 'septembre';
END IF;


 SET  p_moisApayer =v_moisApayer; 
 
 select v_dernierMoisPaye  ;

END |

DELIMITER ;
