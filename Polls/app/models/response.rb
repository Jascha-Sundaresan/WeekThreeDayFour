# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  answer_choice_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cant_respond_to_own_poll
  
  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )
  
  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )
  
  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )
  
  def sibling_responses
    case self.id
    when nil
      question.responses
    else
      question.responses.where('responses.id != ?', self.id)
    end
  end
  
  private
  
  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: user_id)
      errors[:respondent] << "Respondent has already answered question" 
    end
  end
  
  def this_is_your_poll?
    Poll.joins(questions: :answer_choices)
          .exists?(['author_id = ? AND answer_choices.id = ?', 
          user_id, answer_choice_id])  
  end
  
  def author_cant_respond_to_own_poll
    if this_is_your_poll? #question.author.id == user_id
      errors[:poll_owner] << "Author can't respond to own poll"
    end
  end
end
