# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :project
  belongs_to :user
end
