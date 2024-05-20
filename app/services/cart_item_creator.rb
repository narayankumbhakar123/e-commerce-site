class CartItemCreator

    def initialize(current_cart, chosen_product)
        @current_cart = current_cart 
        @chosen_product = chosen_product
    end

    def add_items_to_cart
        if @current_cart.products.include?(@chosen_product)
            @cart_item = @current_cart.cart_items.find_by(product_id: @chosen_product)
            @cart_item.quantity += 1
        else
            @cart_item = CartItem.new
            @cart_item.cart = @current_cart
            @cart_item.product = @chosen_product
            @cart_item.quantity = 1
        end
        @cart_item
    end
  end