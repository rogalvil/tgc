# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :orders, dependent: :destroy, inverse_of: :user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence: true, format: { with: /\A[\p{L}\p{M} ]+\z/ }

  enum role: { customer: 'customer', admin: 'admin', guest: 'guest' }
end
