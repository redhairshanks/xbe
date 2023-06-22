require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  # Your other tests here...

  it "checks changes to table" do
    total_notifs_before = Notification.all.length 
    inv = Invoice.first
    inv_item = InvoiceItem.first
    inv_item.quantity = rand(1..10)
    inv_item.save
    puts "inv_item #{inv_item.errors.messages}"
    total_notifs_after = Notification.all.length
    expect(total_notifs_after).to eq(total_notifs_before + 1)
  end
end
