class Poll < ActiveRecord::Base
  validates :title, :author, presence: true
  validates :title, uniqueness: true
end
