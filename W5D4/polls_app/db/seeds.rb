# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do
  User.destroy_all
  user1 = User.create!(username: "Brenda")
  user2 = User.create!(username: "Kevin")
  user3 = User.create!(username: "Ramsay")
  user4 = User.create!(username: "Karen")
  user5 = User.create!(username: "Eliza")
  user6 = User.create!(username: "Beth")
  user7 = User.create!(username: "George")
  user8 = User.create!(username: "Paul")
  user9 = User.create!(username: "Stacey")
  user10 = User.create!(username: "Brent")

  Poll.destroy_all
  poll1 = Poll.create!(title: "My First Poll", user_id: user1.id)
  poll2 = Poll.create!(title: "Public Recreation", user_id: user1.id)

  Question.destroy_all
  #   poll1 questions
  quest1 = Question.create!(text: "Is this a good first question?", poll_id: poll1.id)
  quest2 = Question.create!(text: "Having a good day?", poll_id: poll1.id)
  #   poll2 questions
  quest3 = Question.create!(text: "Do you like the park?", poll_id: poll2.id)
  quest4 = Question.create!(text: "Last time you played at park?", poll_id: poll2.id)
  quest5 = Question.create!(text: "Do you intend to play at the park soon?", poll_id: poll2.id)

  AnswerChoice.destroy_all
  #   poll1 questions, answers
  #   quest1 answers
  ans1 = AnswerChoice.create!(text: "Yes", question_id: quest1.id)
  ans2 = AnswerChoice.create!(text: "No", question_id: quest1.id)
  ans3 = AnswerChoice.create!(text: "Maybe", question_id: quest1.id)
  #   quest2 answers
  ans4 = AnswerChoice.create!(text: "Yes", question_id: quest2.id)
  ans5 = AnswerChoice.create!(text: "No", question_id: quest2.id)
  ans6 = AnswerChoice.create!(text: "Maybe", question_id: quest2.id)

  #   poll2 questions, answers
  #   quest3 answers
  ans7 = AnswerChoice.create!(text: "Yes", question_id: quest3.id)
  ans8 = AnswerChoice.create!(text: "No", question_id: quest3.id)
  ans9 = AnswerChoice.create!(text: "Maybe", question_id: quest3.id)
  #   quest4 answers
  ans10 = AnswerChoice.create!(text: "Last Week", question_id: quest4.id)
  ans11 = AnswerChoice.create!(text: "Last Month", question_id: quest4.id)
  ans12 = AnswerChoice.create!(text: "Last Year", question_id: quest4.id)
  #   quest5 answers
  ans13 = AnswerChoice.create!(text: "Yes", question_id: quest5.id)
  ans14 = AnswerChoice.create!(text: "No", question_id: quest5.id)
  ans15 = AnswerChoice.create!(text: "Maybe", question_id: quest5.id)

  Response.destroy_all
  # poll1 questions, responses
  #   quest1 responses
  resp1 = Response.create!(user_id: user2.id, answer_id: ans1.id)
  resp2 = Response.create!(user_id: user6.id, answer_id: ans1.id)
  resp3 = Response.create!(user_id: user10.id, answer_id: ans2.id)
  resp4 = Response.create!(user_id: user5.id, answer_id: ans3.id)
  resp5 = Response.create!(user_id: user8.id, answer_id: ans3.id)
  resp6 = Response.create!(user_id: user9.id, answer_id: ans2.id)
  resp7 = Response.create!(user_id: user3.id, answer_id: ans1.id)
  resp8 = Response.create!(user_id: user5.id, answer_id: ans1.id)
  #   quest2 responses
  resp9 = Response.create!(user_id: user2.id, answer_id: ans5.id)
  resp10 = Response.create!(user_id: user6.id, answer_id: ans6.id)
  resp11 = Response.create!(user_id: user10.id, answer_id: ans4.id)
  resp12 = Response.create!(user_id: user5.id, answer_id: ans4.id)
  resp13 = Response.create!(user_id: user8.id, answer_id: ans5.id)
  resp14 = Response.create!(user_id: user9.id, answer_id: ans4.id)
  resp15 = Response.create!(user_id: user3.id, answer_id: ans4.id)
  resp16 = Response.create!(user_id: user5.id, answer_id: ans4.id)

  # poll2 questions, responses
  #   quest3 responses
  resp17 = Response.create!(user_id: user4.id, answer_id: ans7.id)
  resp18 = Response.create!(user_id: user6.id, answer_id: ans8.id)
  resp19 = Response.create!(user_id: user10.id, answer_id: ans9.id)
  resp20 = Response.create!(user_id: user5.id, answer_id: ans7.id)
  resp21 = Response.create!(user_id: user8.id, answer_id: ans8.id)
  resp22 = Response.create!(user_id: user9.id, answer_id: ans7.id)
  resp23 = Response.create!(user_id: user3.id, answer_id: ans9.id)
  resp24 = Response.create!(user_id: user7.id, answer_id: ans7.id)
  #   quest4 responses
  resp25 = Response.create!(user_id: user4.id, answer_id: ans11.id)
  resp26 = Response.create!(user_id: user6.id, answer_id: ans10.id)
  resp27 = Response.create!(user_id: user10.id, answer_id: ans12.id)
  resp28 = Response.create!(user_id: user5.id, answer_id: ans10.id)
  resp29 = Response.create!(user_id: user8.id, answer_id: ans10.id)
  resp30 = Response.create!(user_id: user9.id, answer_id: ans11.id)
  resp31 = Response.create!(user_id: user3.id, answer_id: ans10.id)
  resp32 = Response.create!(user_id: user7.id, answer_id: ans12.id)
  #   quest5 responses
  resp33 = Response.create!(user_id: user4.id, answer_id: ans13.id)
  resp34 = Response.create!(user_id: user6.id, answer_id: ans13.id)
  resp35 = Response.create!(user_id: user10.id, answer_id: ans14.id)
  resp36 = Response.create!(user_id: user5.id, answer_id: ans15.id)
  resp37 = Response.create!(user_id: user8.id, answer_id: ans13.id)
  resp38 = Response.create!(user_id: user9.id, answer_id: ans14.id)
  resp39 = Response.create!(user_id: user3.id, answer_id: ans14.id)
  resp40 = Response.create!(user_id: user7.id, answer_id: ans14.id)
end
