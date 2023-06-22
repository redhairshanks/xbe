class CreateInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_items, id: :uuid do |t|
      t.belongs_to :invoice, null: false, foreign_key: true, type: :uuid
      t.string :quantity
      t.integer :amount_per_unit
      t.integer :total_amount
      t.timestamps
    end
  end
end
