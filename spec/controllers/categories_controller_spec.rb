require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  before do
    @user = FactoryBot.create :user
    @category = FactoryBot.create :category
  end

  describe "GET #index" do
    it "renders template successfully" do
      get :index, params: { name: "test", format: :json }
      json = JSON.parse(response.body)
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do

      it "creates categoris" do
        file = fixture_file_upload('wrong_image.jpg', 'image/jpeg')
        categories_count = Category.count
        post :create, params: { name: "books", image: file }
        json = JSON.parse(response.body)
        expect(Category.count).to eq categories_count + 1
      end
    end

    it "giveses validation error if category name is not present" do
      post :create, params: {name: nil, format: :json}
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq(["Name can't be blank"])
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST #update" do
    context "with valid params" do
      let(:category_update_params) do
        { name: "Tour and travels", id: @category.id }
      end

      it "updates category" do
        put :update, params: category_update_params
        @category.reload
        expect(@category.name).to eq "Tour and travels"
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders error for invalid category id" do
        put :update, params: { name: "Tour and travels", id: "invalid id" }
        json = JSON.parse(response.body)
        expect(json["errors"]).to eq("category not found")
        expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "return the category" do
      get :show, params: { id: @category.id }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(@category.id).to eq(json["id"])
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "deletes category" do
      @category2 = FactoryBot.create :category
      count = Category.count
      delete :destroy, params: { id: @category2.id }
      json = JSON.parse(response.body)
      expect(Category.count).to eq count - 1
      expect(json["message"]).to eq("category successfully deleted")
      expect(response).to have_http_status(:ok)
    end
  end
end
