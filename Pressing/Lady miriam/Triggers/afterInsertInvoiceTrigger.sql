drop trigger if exists afterInsertInvoiceTrigger;

delimiter |

create trigger afterInsertInvoiceTrigger before insert on accompte for each row
begin
declare v_total_paye decimal default 0;
declare v_total_a_paye decimal default 0;
declare v_invoice_id bigint default 0;

-- le montant total à payer
select ifnull(sum(negociated_price*amount),0) into v_total_a_paye  from detailsfacturepressing where invoice_id = new.invoice_id;

-- le montant total deja payé 

select ifnull(sum(montant),0) into v_total_paye from accompte where invoice_id = new.invoice_id;

IF v_total_paye >= v_total_paye THEN 

	UPDATE invoices set Ispayed = true where id = new.invoice_id;
    
END IF;

end |

delimiter ;

