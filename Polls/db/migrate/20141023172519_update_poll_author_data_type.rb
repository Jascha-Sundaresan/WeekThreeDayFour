class UpdatePollAuthorDataType < ActiveRecord::Migration
  def change
    remove_column(:polls, :author)
    add_column(:polls, :author_id, :integer)
  end
end
