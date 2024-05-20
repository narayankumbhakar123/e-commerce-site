class CartsController < ApplicationController
    before_action :set_cart, only: %i[ show destroy ]
    
    def cart_by_date
        @carts = Cart.all.group_by { |c| c.created_at.to_date }
        render json: @carts
    end

    def show
        render(json: CartSerializer.new(@cart).serializable_hash.to_json)
    end

    def destroy
        @cart.destroy
        render json: { message: "cart successfully deleted"}
    end

    private

    def set_cart
        @cart = Cart.find(params[:id])
    end

    def cart_params
        params.require(:cart).permit(:user_id)
    end
end
