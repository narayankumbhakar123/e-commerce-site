require "rails_helper"

RSpec.describe PaymentsController, type: :controller do
  before do
    @user = FactoryBot.create :user
    @cart = FactoryBot.create :cart, {user_id: @user.id}
    @category = FactoryBot.create :category
    @product = FactoryBot.create :product, {category_id: @category.id, price: 500 }
    @cart_item = FactoryBot.create :cart_item, { cart_id: @cart.id, product_id: @product.id, quantity: 1 }
    @order = FactoryBot.create :order, { user: @user, description: "ordered is created" }
  end

  describe "POST #create" do
    context "with valid params" do
      let(:payment_params) do
        { order_id: @order.id, format: :json}
      end

      it "will create payment for the given order" do
        payment_count = Payment.count
        post :create, params: payment_params
        json = JSON.parse(response.body)
        expect(Order.count).to eq payment_count + 1
      end
    end

    it "will render error for invalid order id" do
        post :create, params: { order_id: "order_id", format: :json}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["errors"]).to eq("order not found")
        expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #update" do
    context "with valid params" do
      it "updates payment" do
        @payment = FactoryBot.create :payment, {order_id: @order.id, status: "failed", transaction_id: "32f19715aebe2a176fa83fe8608c1d2d"}
        patch :update, params: {id: @payment.id, order_id: @order.id, status: "completed" }
        @payment.reload
        expect(@payment.status).to eq "completed"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
