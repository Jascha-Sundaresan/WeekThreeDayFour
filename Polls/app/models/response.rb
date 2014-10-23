class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
end
