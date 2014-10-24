# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :string(255)
#  poll_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true
  
  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )
  
  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )
  
  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )
  
  has_one(
    :author,
    through: :poll,
    source: :author
  )
  
  def results
    results = {}
    answer_choices = self.answer_choices.includes(:responses)
    
    answer_choices.each do |answer_choice|
      results[answer_choice.text] = answer_choice.responses.length
    end
    
    results
  end
  
  def results_via_join
    select_query = <<-SELECT
    answer_choices.*, 
    SUM(
      CASE 
        WHEN responses.answer_choice_id is NULL 
        THEN 0 
        ELSE 1 
        END
      ) AS responses_count
    SELECT
    
    joins_query = <<-JOINS
     LEFT OUTER JOIN 
       responses 
     ON 
       responses.answer_choice_id = answer_choices.id
    JOINS
    
    answers_with_counts = self
    .answer_choices
    .select(select_query)
    .joins(joins_query)
    .group("answer_choices.id")

    answers_with_counts.map do |answer|
      [answer.text, answer.responses_count]
    end

  end

end







    # (<<-SQL, self.id)
#     SELECT answer_choices.*, COUNT(*) AS responses_count
#              FROM answer_choices
#   LEFT OUTER JOIN responses
#                ON responses.answer_choice_id = answer_choices.id
#             WHERE answer_choices.question_id = ?
#          GROUP BY answer_choices.id
#     SQL
