# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

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
  
  def completed_via_sql
    query = <<-SQL
    SELECT polls.*
    FROM polls
    JOIN questions
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
  
  def completed_via_ar
   
    completed_polls = Poll
      .joins(:questions)
      .joins('LEFT OUTER JOIN answer_choices ON questions.id = answer_choices.question_id')
      .joins('LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id')
      .where('responses.user_id = ? OR responses.user_id IS NULL', self.id)
      .group("polls.id")
      .having("COUNT(DISTINCT questions.id) = COUNT(DISTINCT responses.id)")
    
    completed_polls
    
  end
  
  def uncompleted_via_ar
   
    uncompleted_polls = Poll
      .joins(:questions)
      .joins('LEFT OUTER JOIN answer_choices ON questions.id = answer_choices.question_id')
      .joins('LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id')
      .where('responses.user_id = ? OR responses.user_id IS NULL', self.id)
      .group("polls.id")
      .having("COUNT(DISTINCT questions.id) > COUNT(DISTINCT responses.id) AND COUNT(DISTINCT responses.id) > 0")
    
    uncompleted_polls
    
  end
end
