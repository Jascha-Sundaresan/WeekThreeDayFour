class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true
  
  has_many(
    :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id  
  )
  
  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id  
  )
  
  def completed
    query = <<-SQL
    SELECT polls.*
    FROM polls
    LEFT OUTER JOIN questions
    ON polls.id = questions.poll_id
    LEFT OUTER JOIN answer_choices
    ON questions.id = answer_choices.question_id
    LEFT OUTER JOIN (
      SELECT responses.*
      FROM responses
      WHERE responses.user_id = ?
    ) AS user_responses
    ON user_responses.answer_choice_id = answer_choices.id
    GROUP BY polls.id
    HAVING COUNT(DISTINCT questions.id) = COUNT(DISTINCT user_responses.id)
    SQL
    Poll.find_by_sql([query, self.id])

  end
  
end
