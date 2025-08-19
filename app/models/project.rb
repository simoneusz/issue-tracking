# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user

  has_many :issues, dependent: :nullify
  has_many :assigned_issues, class_name: 'Issue', dependent: :nullify, inverse_of: :assignee

  validates :name, presence: true
  validates :description, presence: true

  # either project.user == user or issue.assignee == user
  scope :by_user, lambda { |user|
    left_joins(:issues)
      .where("projects.user_id = :user_id OR issues.assignee_id = :user_id", user_id: user.id)
      .distinct
  }
end
