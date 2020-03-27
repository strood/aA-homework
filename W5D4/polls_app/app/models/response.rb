# == Schema Information
#
# Table name: responses
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  answer_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Response < ApplicationRecord
  validates :user_id, presence: true
  validates :answer_id, presence: true
  validate :respondent_already_answered?
  validate :their_own_poll?

  belongs_to :answer_choice,
             primary_key: :id,
             foreign_key: :answer_id,
             class_name: :AnswerChoice

  belongs_to :respondent,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User

  has_one :question,
          through: :answer_choice,
          source: :question

  def sibling_responses
    # Filtered so it doesnt include itself. where.not to deal with ternary logic
    self.question.responses.where.not("responses.id = ?", self.id)
  end

  def respondent_already_answered?
    has_answered = self.sibling_responses.exists?(id: self.respondent.id)
    if has_answered
      errors[:id] << "User ID '#{self.user_id}' has already answered this question"
    end
  end

  def poll_author_id
    self.question.poll.author.id
  end

  def their_own_poll?
    # self.poll_author_id == self.respondent.id
    author_of_pole = self.question.poll.author.id == self.respondent.id
    if author_of_pole
      errors[:id] << "User ID '#{self.user_id}' is the author of this poll"
    end
  end
end
