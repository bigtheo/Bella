drop trigger if exists beforeInsertInDetailsFactureTrigger;

delimiter |

create trigger beforeInsertInDetailsFactureTrigger before insert on detailsfactureboutique for each row

BEGIN
insert into stock(amount,operation,product_id) values(- new.amount,'out',new.product_id);
END |

Delimiter ;