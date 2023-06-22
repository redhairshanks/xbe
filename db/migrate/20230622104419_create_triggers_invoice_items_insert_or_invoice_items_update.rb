# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersInvoiceItemsInsertOrInvoiceItemsUpdate < ActiveRecord::Migration[7.0]
  def up
    create_trigger("invoice_items_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:insert) do
      "UPDATE invoices SET total_amount = total_amount + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;"
    end

    create_trigger("invoice_items_after_update_of_quantity_amount_per_unit_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:update).
        of(:quantity, :amount_per_unit) do
      "UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) + (NEW.quantity * NEW.amount_per_unit) where id = NEW.invoice_id;"
    end
  end

  def down
    drop_trigger("invoice_items_after_insert_row_tr", "invoice_items", :generated => true)

    drop_trigger("invoice_items_after_update_of_quantity_amount_per_unit_row_tr", "invoice_items", :generated => true)
  end
end
