class CartItemsController < ApplicationController

    def create
        # Find associated product and current cart
        chosen_product = Product.find(params[:product_id])
        current_cart = Cart.find(params[:cart_id])
        @cart_item = CartItemCreator.new(current_cart, chosen_product ).add_items_to_cart

        if @cart_item.save!
            render(json: CartItemSerializer.new(@cart_item).serializable_hash.to_json)
        else
            render json: { errors: @cart_item.errors.full_messages },
            status: :unprocessable_entity
        end
    end

    def destroy
        @cart_item = CartItem.find(params[:id])
        @cart_item.destroy
        render json: { message: "cart item successfully deleted"}
    end

    def add_quantity
        @cart_item = CartItem.find(params[:id])
        @cart_item.quantity += 1
        if @cart_item.save
            render(json: CartItemSerializer.new(@cart_item).serializable_hash.to_json)
        end
    end

    def reduce_quantity
        @cart_item = CartItem.find(params[:id])
        if @cart_item.quantity > 1
            @cart_item.quantity -= 1
            if @cart_item.save
                render(json: CartItemSerializer.new(@cart_item).serializable_hash.to_json)
            end
        elsif @cart_item.quantity == 1
            destroy
        end
    end

    private

    def cart_item_params
        params.require(:cart_item).permit(:quantity, :price, :product_id, :cart_id, :order_id)
    end
end
