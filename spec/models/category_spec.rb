require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:products) }
    it { should have_one_attached(:image) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
  end
end
