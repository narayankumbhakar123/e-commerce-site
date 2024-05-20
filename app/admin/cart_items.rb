ActiveAdmin.register CartItem do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :quantity, :product_id, :cart_id, :order_id

  scope :all
  scope :ordered
  scope :unorder
  
  #
  # or
  #
  # permit_params do
  #   permitted = [:quantity, :product_id, :cart_id, :order_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
