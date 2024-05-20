require "rails_helper"

RSpec.describe UsersController, type: :controller do
  before do
    @user = FactoryBot.create :user
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
      let(:user_params) do
        { name: "narayan", username: "narayankumar", email: "narayan@metafic.com", password: "test@1234" }
      end

      it "creates user" do
        users_count = User.count
        post :create, params: user_params
        json = JSON.parse(response.body)
        expect(User.count).to eq users_count + 1
      end
    end

    it "gives validation error if user email is blank" do
      post :create, params: {name: "narayan", username: "narayankumar", email: nil, password: "test@1234", format: :json}
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq(["Email can't be blank", "Email is invalid"])
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST #update" do
    context "with valid params" do
        let(:user_update_params) do
            { id: @user.id, name: "test", username: "narayankumar", email: "narayan@metafic.com", password: "test@1234" }
          end

      it "updates user" do
        put :update, params: user_update_params
        @user.reload
        expect(@user.name).to eq "test"
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders error for invalid user id" do
        put :update, params: { name: "Tour and travels", id: "invalid id" }
        json = JSON.parse(response.body)
        expect(json["errors"]).to eq("User not found")
        expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "return the user" do
      get :show, params: { id: @user.id }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(@user.id).to eq(json["data"]["id"].to_i)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "deletes user" do
      @user2 = FactoryBot.create :user, {email: "test@gmail.com", username: "testuser2"}
      count = User.count
      delete :destroy, params: { id: @user2.id }
      json = JSON.parse(response.body)
      expect(User.count).to eq count - 1
      expect(json["message"]).to eq("user successfully deleted")
      expect(response).to have_http_status(:ok)
    end
  end
end
