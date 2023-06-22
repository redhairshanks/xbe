class InvoiceItem < ApplicationRecord

	belongs_to :invoice

	trigger.after(:insert) do 
		"BEGIN
		 	UPDATE invoices SET total_amount = total_amount + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;
		 	PERFORM pg_notify('trigger_changes', '{table: invoice_items, event: new, data: {quantity: NEW.quantity, amount_per_unit: NEW.amount_per_unit}}');
		 END
		"
	end


	trigger.after(:update).of(:quantity, :amount_per_unit) do 
		"BEGIN
			UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;
			PERFORM pg_notify('trigger_changes', '{table: invoice_items, event: update, data: {quantity: NEW.quantity, amount_per_unit: NEW.amount_per_unit, old_quantity: OLD.quantity, old_amount_per_unit: OLD.amount_per_unit}}');
		 END 	
		"
	end

	trigger.after(:delete) do 
		"BEGIN
			UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) where id = OLD.invoice_id;
			PERFORM pg_notify('trigger_changes', '{table: invoice_items, event: delete, data: {old_quantity: OLD.quantity, old_amount_per_unit: OLD.amount_per_unit}}');
		 END
		"
	end
	
end