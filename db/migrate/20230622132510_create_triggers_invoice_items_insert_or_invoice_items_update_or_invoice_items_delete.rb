# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersInvoiceItemsInsertOrInvoiceItemsUpdateOrInvoiceItemsDelete < ActiveRecord::Migration[7.0]
  def up
    drop_trigger("invoice_items_after_insert_row_tr", "invoice_items", :generated => true)

    drop_trigger("invoice_items_after_update_of_quantity_amount_per_unit_row_tr", "invoice_items", :generated => true)

    drop_trigger("invoice_items_after_delete_row_tr", "invoice_items", :generated => true)

    create_trigger("invoice_items_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:insert) do
      <<-SQL_ACTIONS
BEGIN
		 	UPDATE invoices SET total_amount = total_amount + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;
		 	PERFORM pg_notify('trigger_changes', '{table: invoice_items, event: new, data: {quantity: NEW.quantity, amount_per_unit: NEW.amount_per_unit}}');
		 END;
      SQL_ACTIONS
    end

    create_trigger("invoice_items_after_update_of_quantity_amount_per_unit_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:update).
        of(:quantity, :amount_per_unit) do
      <<-SQL_ACTIONS
BEGIN
			UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;
			PERFORM pg_notify('trigger_changes', '{table: invoice_items, event: update, data: {quantity: NEW.quantity, amount_per_unit: NEW.amount_per_unit, old_quantity: OLD.quantity, old_amount_per_unit: OLD.amount_per_unit}}');
		 END;
      SQL_ACTIONS
    end

    create_trigger("invoice_items_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:delete) do
      <<-SQL_ACTIONS
BEGIN
			UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) where id = OLD.invoice_id;
			PERFORM pg_notify('trigger_changes', '{table: invoice_items, event: delete, data: {old_quantity: OLD.quantity, old_amount_per_unit: OLD.amount_per_unit}}');
		 END;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("invoice_items_after_insert_row_tr", "invoice_items", :generated => true)

    drop_trigger("invoice_items_after_update_of_quantity_amount_per_unit_row_tr", "invoice_items", :generated => true)

    drop_trigger("invoice_items_after_delete_row_tr", "invoice_items", :generated => true)

    create_trigger("invoice_items_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:insert) do
      <<-SQL_ACTIONS
BEGIN
		 	UPDATE invoices SET total_amount = total_amount + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;
		 	PERFORM pg_notify('trigger_changes', '{table: invoice}');
		 END;
      SQL_ACTIONS
    end

    create_trigger("invoice_items_after_update_of_quantity_amount_per_unit_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:update).
        of(:quantity, :amount_per_unit) do
      <<-SQL_ACTIONS
BEGIN
			UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;
			PERFORM pg_notify('trigger_changes', '{table: invoice}');
		 END;
      SQL_ACTIONS
    end

    create_trigger("invoice_items_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:delete) do
      <<-SQL_ACTIONS
BEGIN
			UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) where id = OLD.invoice_id;
			PERFORM pg_notify('trigger_changes', '{table: invoice}');
		 END;
      SQL_ACTIONS
    end
  end
end
