# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  before do
    @category = FactoryBot.create :category
    @product = FactoryBot.create :product, {category_id: @category.id}
  end

  describe "GET #index" do
    it "renders template successfully" do
      get :index, params: { format: :json }
      json = JSON.parse(response.body)
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:product_params) do
        { name: "mobile", manufacturer: "realme", price: 1000, prod_desc: "8gb ram oled display", prod_feature: "1 yr warrenty", category_id: @category.id }
      end

      it "creates product" do
        product_count = Product.count
        post :create, params: product_params
        json = JSON.parse(response.body)
        expect(Product.count).to eq product_count + 1
      end
    end
  end

  describe "POST #update" do
    context "with valid params" do
        let(:product_update_params) do
            { id: @product.id, name: "Tv",price: 500, manufacturer: "realme", prod_desc: "8gb ram oled display", prod_feature: "1 yr warrenty", category_id: @category.id }
          end

      it "updates product" do
        put :update, params: product_update_params
        @product.reload
        expect(@product.name).to eq "Tv"
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders error for invalid product id" do
        put :update, params: { name: "Tour and travels", id: "invalid id" }
        json = JSON.parse(response.body)
        expect(json["errors"]).to eq("product not found")
        expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "return the user" do
      get :show, params: { id: @product.id }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(@product.id).to eq(json["id"])
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "deletes user" do
      @product2 = FactoryBot.create :product, {category_id: @category.id}
      count = Product.count
      delete :destroy, params: { id: @product2.id }
      json = JSON.parse(response.body)
      expect(Product.count).to eq count - 1
      expect(json["message"]).to eq("product successfully deleted")
      expect(response).to have_http_status(:ok)
    end
  end
end
