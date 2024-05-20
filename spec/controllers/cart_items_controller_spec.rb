require "rails_helper"

RSpec.describe CartItemsController, type: :controller do
  before do
    @user = FactoryBot.create :user
    @cart = FactoryBot.create :cart, {user_id: @user.id}
    @category = FactoryBot.create :category
    @product = FactoryBot.create :product, {category_id: @category.id }
  end

  describe "POST #create" do
    context "with valid params" do
      let(:cart_items_params) do
        { cart_id: @cart.id, product_id: @product.id }
      end

      it "creates cart_item" do
        cart_item_count = CartItem.count
        post :create, params: cart_items_params
        json = JSON.parse(response.body)
        expect(json["data"]["attributes"]["quantity"]).to eq(1)
        expect(json["data"]["attributes"]["price_per_unit"]).to eq(50000)
        expect(json["data"]["attributes"]["total_price"]).to eq(50000)
        expect(CartItem.count).to eq cart_item_count + 1
      end

      it "if the product is already present in the cart item than it will increase the quantity of product by 1" do
        user = FactoryBot.create :user, {username: "testuser", email: "testing_4@gmail.com"}
        cart = FactoryBot.create :cart, {user_id: user.id}
        category = FactoryBot.create :category
        product = FactoryBot.create :product, {category_id: category.id, price: 500 }
        cart_item2 = FactoryBot.create :cart_item, { cart_id: cart.id, product_id: product.id, quantity: 1 }
        post :create, params: { cart_id: cart.id, product_id: product.id }
        json = JSON.parse(response.body)
        expect(json["data"]["attributes"]["quantity"]).to eq(2)
        expect(json["data"]["attributes"]["price_per_unit"]).to eq(500)
        expect(json["data"]["attributes"]["total_price"]).to eq(1000)
      end
    end
  end

  describe "POST #add_quantity" do
    it "increases the quantity by 1 for cart_item" do
        @user2 = FactoryBot.create :user, {username: "test_user", email: "test_4@gmail.com"}
        @cart2 = FactoryBot.create :cart, {user_id: @user2.id}
        @category2 = FactoryBot.create :category
        @product2 = FactoryBot.create :product, {category_id: @category2.id, price: 500 }
        @cart_item2 = FactoryBot.create :cart_item, { cart_id: @cart2.id, product_id: @product2.id, quantity: 1 }
        post :add_quantity, params: { id: @cart_item2.id }
        json = JSON.parse(response.body)
        @cart_item2.reload
        expect(json["data"]["attributes"]["price_per_unit"]).to eq(500)
        expect(json["data"]["attributes"]["total_price"]).to eq(1000)
        expect(@cart_item2.quantity).to eq(2)
        expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #reduce_quantity" do
    it "decrease the quantity by 1 for  cart_item" do
        @user3 = FactoryBot.create :user, {username: "test_user", email: "test_4@gmail.com"}
        @cart3 = FactoryBot.create :cart, {user_id: @user3.id}
        @category3 = FactoryBot.create :category
        @product3 = FactoryBot.create :product, {category_id: @category3.id, price: 500 }
        @cart_item3 = FactoryBot.create :cart_item, { cart_id: @cart3.id, product_id: @product3.id, quantity: 4 }
        post :reduce_quantity, params: { id: @cart_item3.id }
        json = JSON.parse(response.body)
        @cart_item3.reload
        expect(json["data"]["attributes"]["price_per_unit"]).to eq(500)
        expect(json["data"]["attributes"]["total_price"]).to eq(1500)
        expect(@cart_item3.quantity).to eq(3)
        expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "deletes cart_item" do
        @user4 = FactoryBot.create :user, {username: "test_user", email: "test_4@gmail.com"}
        @cart4 = FactoryBot.create :cart, {user_id: @user4.id}
        @category4 = FactoryBot.create :category
        @product4 = FactoryBot.create :product, {category_id: @category4.id }
        @cart_item4 = FactoryBot.create :cart_item, { cart_id: @cart4.id, product_id: @product4.id }
        count = CartItem.count
        delete :destroy, params: { id: @cart_item4.id }
        json = JSON.parse(response.body)
        expect(CartItem.count).to eq count - 1
        expect(json["message"]).to eq("cart item successfully deleted")
        expect(response).to have_http_status(:ok)
    end
  end
end
