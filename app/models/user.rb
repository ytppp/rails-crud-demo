class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(.[a-zA-Z0-9_-]+)+\Z/ }
  validates :password_digest, presence: true
  validates :role, inclusion: { in: [0, 1, 2], message: "role can be only in [0 1 2]" }

  has_one :shop, dependent: :destroy

  has_secure_password
end
