class DeviseUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable :registerable, :recoverable, :rememberable, and :omniauthable
  devise :database_authenticatable, :validatable

  belongs_to :company
end
