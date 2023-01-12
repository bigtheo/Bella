drop trigger if exists afterInsertaccompteTrigger;
delimiter |
CREATE  TRIGGER `afterInsertaccompteTrigger` AFTER INSERT ON `accompte` FOR EACH ROW begin
declare v_total decimal default 0;
declare v_prix_mensuel decimal default 0;


select sum(montant) into v_total from accompte where frais_mensuel_id=new.frais_mensuel_id AND eleve_id=new.eleve_id;

select montant into v_prix_mensuel from frais_mensuel where id=new.frais_mensuel_id;


IF (v_total is not null and v_prix_mensuel is not null) and (v_total >= v_prix_mensuel) THEN

call InsertDansPaiementMensuels(null,new.eleve_id,new.frais_mensuel_id,1,true);
END IF;

end |