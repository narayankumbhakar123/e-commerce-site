class CategoriesController < ApplicationController
  # skip_before_action :authenticate_request, only: [:create]
    before_action :set_category, only: %i[ show edit update destroy ]

    def index
        @categories = Category.all

        render(json: CategorySerializer.new(@categories).serializable_hash.to_json)
    end

    def show
        render json: @category, status: :ok
    end

    def create
      @category = Category.new(category_params)
        if @category.save
        render json: @category, status: :created
        else
        render json: { errors: @category.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    def update
      if @category.update(category_params)
        render json: @category
      else
        render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      render json: { message: "category successfully deleted"}
    end

    private

    def set_category
      @category = Category.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'category not found' }, status: :not_found
    end

    def category_params
      params.permit(:name, :image)
    end
end
