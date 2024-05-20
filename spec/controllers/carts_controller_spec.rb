# frozen_string_literal: true

require "rails_helper"

RSpec.describe CartsController, type: :controller do
  before do
    @user = FactoryBot.create :user
    @cart = FactoryBot.create :cart, { user_id: @user.id }
  end

  describe "GET #show" do
    it "return the category" do
      get :show, params: { id: @cart.id }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(@cart.id).to eq(json["data"]["id"].to_i)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "deletes category" do
      @user2 = FactoryBot.create :user, {username: "test2", email: "testing@gmail.com"}
      @cart2 = FactoryBot.create :cart, {user_id: @user2.id}
      count = Cart.count
      delete :destroy, params: { id: @cart2.id }
      json = JSON.parse(response.body)
      expect(Cart.count).to eq count - 1
      expect(json["message"]).to eq("cart successfully deleted")
      expect(response).to have_http_status(:ok)
    end
  end
end