class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :user_id, presence: true
      t.integer :answer_choice_id, presence: true

      t.timestamps
    end
    
    add_index :responses, [:user_id, :answer_choice_id], :unique => true
  end
end
