class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true
end
