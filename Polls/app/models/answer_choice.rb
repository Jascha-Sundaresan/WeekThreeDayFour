class AnswerChoice < ActiveRecord::Base
  validates :text, :question_id, presence: true
end
