require "rails_helper"

RSpec.describe User, type: :model do
    describe "associations" do
        it { is_expected.to have_one(:cart) }
        it { is_expected.to have_many(:orders).dependent(:destroy) }
    end

    describe "validations" do
        it { is_expected.to validate_presence_of :email }
        it { is_expected.to validate_presence_of :username }
        it { is_expected.to validate_uniqueness_of(:email) }
        it { is_expected.to validate_uniqueness_of(:username) }
        it { is_expected.to validate_length_of(:password).is_at_least(6) }
      end
end