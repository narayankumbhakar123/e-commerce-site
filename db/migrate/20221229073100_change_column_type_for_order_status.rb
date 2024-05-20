class ChangeColumnTypeForOrderStatus < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :status, 'integer USING CASE
      WHEN status = \'pending\' THEN 0
      WHEN status = \'shipped\' THEN 1
      WHEN status = \'delivered\' THEN 2
      ELSE NULL
    END'
  end
end
