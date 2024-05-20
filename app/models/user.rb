class User < ApplicationRecord
    has_secure_password

    has_one :cart, dependent: :destroy
    has_many :orders, dependent: :destroy
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, presence: true, uniqueness: true
    validates :name, presence: true
    validates :password,
              length: { minimum: 6 },
              if: -> { new_record? || !password.nil? }
    
end
