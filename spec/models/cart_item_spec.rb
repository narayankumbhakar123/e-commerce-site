require "rails_helper"

RSpec.describe CartItem, type: :model do
    describe "associations" do
        it { is_expected.to belong_to(:product) }
        it { is_expected.to belong_to(:cart).optional }
        it { is_expected.to belong_to(:order).optional }
    end

    context "when instance methods" do
        before do
            @category = FactoryBot.create :category
            @product = FactoryBot.create :product, {category_id: @category.id, price: 50000}
            @cart_item = FactoryBot.create :cart_item, { product: @product, quantity: 2 }
        end

        describe "#product_price" do
            it "return total price with multiplied by quantity" do
                expect(@cart_item.product_price).to eq(100000)
            end
        end
    end
end