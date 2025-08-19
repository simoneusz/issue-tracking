require 'faker'


Comment.destroy_all
Issue.destroy_all
Project.destroy_all
User.destroy_all

users = 5.times.map do |i|
  User.create!(
    name: Faker::Name.name,
    email: "user#{i+1}@example.com",
    password: "123123",
    password_confirmation: "123123"
  )
end

projects = users.flat_map do |user|
  rand(2..4).times.map do
    Project.create!(
      name: Faker::App.name,
      description: Faker::Lorem.sentence(word_count: 10),
      user: user
    )
  end
end

statuses = ["Active", "On hold", "Resolved", "Closed"]

projects.each do |project|
  rand(2..5).times do
    issue_user = users.sample
    assignee_user = users.sample

    Issue.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 3),
      status: statuses.sample,
      project: project,
      user: issue_user,
      assignee: assignee_user
    )
  end
end

Issue.all.each do |issue|
  rand(1..3).times do
    Comment.create!(
      body: Faker::Lorem.sentence(word_count: 8),
      issue: issue,
      user: users.sample
    )
  end
end

puts "Seed data created."
puts "email: user1@example.com"
puts "password: 123123"