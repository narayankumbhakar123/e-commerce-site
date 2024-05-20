class OrdersController < ApplicationController
  before_action :set_order,  only: %i[ show update destroy ]

  def index
    @orders = Order.all
    render json: @orders
  end

  def show
    render json: @order
  end

  def create
    @current_cart = Cart.where(user_id: params[:user_id]).first
  
    if @current_cart.cart_items.empty?
      render json: { message: "Your cart is empty" }
    else
      # Create a new order
      @order = Order.new(order_params)
  
      # Wrap the order creation, cart item addition, and payment processing in a transaction
      ActiveRecord::Base.transaction do
        # Add cart items to the order
        add_cart_items_to_order
  
        # Charge the payment using Stripe
        charge = Stripe::Charge.create(
          amount: calculate_order_amount,  # Specify the order amount in cents
          currency: 'inr',
          source: params[:stripeToken]  # Use the Stripe token received from the client-side
        )
  
        # Save the order and update the payment details
        @order.payment_id = charge.id
        @order.payment_status = charge.status
  
        if @order.save
          render json: @order
        else
          raise ActiveRecord::Rollback  # Rollback the transaction if order saving fails
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue Stripe::CardError => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end
  

  def destroy
    @order.destroy
    render json: { message: "order successfully deleted"}
  end

  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def ordered_products
    @order = Order.where(user_id: params[:user_id])
    @products = []
    @order.each do |order|
        order.cart_items.where.not(order_id: nil).each do |cart_item|
            @products << cart_item.product
        end
    end
    render json: @products
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def add_cart_items_to_order
    @current_cart.cart_items.each do |item|
      item.cart_id = nil
      item.order_id = @order.id
      item.save
      @order.cart_items << item
    end
  end

  def calculate_order_amount
    total_amount = 0
  
    @current_cart.cart_items.each do |cart_item|
      product = Product.find(cart_item.product_id)
      total_amount += product.price * cart_item.quantity
    end
  
    total_amount_cents = (total_amount * 100).to_i
    total_amount_cents
  end  

  def order_params
    params.permit(:user_id, :status, :description)
  end
end
