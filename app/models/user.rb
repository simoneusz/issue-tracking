# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :issues, dependent: :nullify
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
