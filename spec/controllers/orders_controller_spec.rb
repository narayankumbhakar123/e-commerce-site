require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  before do
    @user = FactoryBot.create :user
    @cart = FactoryBot.create :cart, {user_id: @user.id}
    @category = FactoryBot.create :category
    @product = FactoryBot.create :product, {category_id: @category.id, price: 500 }
    @cart_item = FactoryBot.create :cart_item, { cart_id: @cart.id, product_id: @product.id, quantity: 1 }
    @order = FactoryBot.create :order, { user: @user, description: "ordered is created" }
  end

  describe "GET #index" do
    it "renders template successfully" do
      get :index, params: { user_id: @user.id, format: :json }
      json = JSON.parse(response.body)
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "return the particular order" do
      get :show, params: { id: @order.id }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(@order.id).to eq(json["id"])
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:order_params) do
        { user_id: @user.id, format: :json}
      end

      it "will create order if cart item is not empty for user" do
        order_count = Order.count
        post :create, params: order_params
        json = JSON.parse(response.body)
        expect(Order.count).to eq order_count + 1
      end
    end

    it "will render error if cart item is empty" do
        @user2 = FactoryBot.create :user, { username: "usr_2", email: "user_test@example.com" }
        @cart2 = FactoryBot.create :cart, {user_id: @user2.id}

        post :create, params: { user_id: @user2, format: :json}
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("you cart is empty")
        expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #update" do
    context "with valid params" do
      let(:update_params) do
        { description: "order is updated", id: @order.id }
      end

      it "updates order" do
        put :update, params: update_params
        @order.reload
        expect(@order.description).to eq "order is updated"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #ordered_products" do
    context "with valid params" do
      it "return all the ordered product for the user" do
        @cart_item.update(cart_id: nil, order_id: @order.id)
        @cart_item.reload
        get :ordered_products, params: {user_id: @user.id}
        json = JSON.parse(response.body)
        expect(@product.id).to eq(json.first["id"])
        expect(response).to have_http_status(:ok)
      end
    end
  end
  

  describe "DELETE #destroy" do
    it "deletes order" do
      count = Order.count
      delete :destroy, params: { id: @order.id }
      json = JSON.parse(response.body)
      expect(Order.count).to eq count - 1
      expect(json["message"]).to eq("order successfully deleted")
      expect(response).to have_http_status(:ok)
    end
  end
end
