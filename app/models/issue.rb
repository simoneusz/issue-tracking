# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :assignee, class_name: 'User'

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
end
