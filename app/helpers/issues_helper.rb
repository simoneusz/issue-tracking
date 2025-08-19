# frozen_string_literal: true

module IssuesHelper
  def status_class(status)
    case status
    when 'Active' then 'bg-success text-white'
    when 'On hold' then 'bg-warning text-dark'
    when 'Resolved' then 'bg-info text-white'
    when 'Closed' then 'bg-secondary text-white'
    else
      'bg-light'
    end
  end
end
