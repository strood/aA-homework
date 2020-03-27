# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :username, presence: true
  validates :username, uniqueness: true

  has_many :authored_polls,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Poll

  has_many :responses,
           primary_key: :id,
           foreign_key: :user_id,
           class_name: :Response

  def completed_polls
    polls_with_completion_counts
      .having("COUNT(DISTINCT questions.id) = COUNT(responses.id)")
  end

  def incomplete_polls
    polls_with_completion_counts
      .having("COUNT(DISTINCT questions.id) > COUNT(responses.id)")
      .having("COUNT(responses.id) > 0")
  end

  private

  def polls_with_completion_counts
    joins_sql = <<-SQL
              LEFT OUTER JOIN (
                SELECT
                  *
                FROM
                  responses
                WHERE
                  respondent_id = #{self.id}
              ) AS responses ON answer_choices.id = responses.answer_choice_id
            SQL

    Poll.joins(questions: :answer_choices)
      .joins(joins_sql)
      .group("polls.id")
  end
end
