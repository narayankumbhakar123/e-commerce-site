class Product < ApplicationRecord
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :orders, through: :cart_items
  validates_numericality_of :price
  validates :manufacturer, presence: true
end
