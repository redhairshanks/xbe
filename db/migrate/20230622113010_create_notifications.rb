class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.string :event 
      t.json :payload, default: {}
      t.timestamps
    end
  end
end
