class AddPaymentFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_id, :string
    add_column :orders, :payment_status, :string
  end
end
