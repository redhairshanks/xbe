# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerInvoiceItemsDelete < ActiveRecord::Migration[7.0]
  def up
    create_trigger("invoice_items_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("invoice_items").
        after(:delete) do
      "UPDATE invoices SET total_amount = total_amount - (OLD.quantity * OLD.amount_per_unit) where id = OLD.invoice_id;"
    end
  end

  def down
    drop_trigger("invoice_items_after_delete_row_tr", "invoice_items", :generated => true)
  end
end
