# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  text       :string           not null
#  poll_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Question < ApplicationRecord
  # Remember, Rails 5 automatically validates the presence of belongs_to associations.
  validates :text, presence: true
  #   validates :poll_id, presence: true

  belongs_to :poll,
             primary_key: :id,
             foreign_key: :poll_id,
             class_name: :Poll

  has_many :answer_choices,
           primary_key: :id,
           foreign_key: :question_id,
           class_name: :AnswerChoice

  has_many :responses,
           through: :answer_choices,
           source: :responses

  def results
    choices = self.answer_choices.includes(:responses)
    results = {}
    choices.each do |choice|
      results[choice.text] = choice.responses.count
    end
    results
  end
end
