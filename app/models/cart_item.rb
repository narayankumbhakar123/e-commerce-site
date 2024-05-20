class CartItem < ApplicationRecord
    belongs_to :product
    belongs_to :cart, optional: true
    belongs_to :order, optional: true

    scope :ordered, -> { where(cart_id: nil) }
    scope :unorder, -> { where.not(cart_id: nil) }

    validates_numericality_of :quantity, :greater_than => 0

    def product_price
        product.price * quantity
    end
end
