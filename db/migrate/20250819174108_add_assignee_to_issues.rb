class AddAssigneeToIssues < ActiveRecord::Migration[8.0]
  def change
    add_reference :issues, :assignee, null: false, foreign_key: { to_table: :users }
  end
end
