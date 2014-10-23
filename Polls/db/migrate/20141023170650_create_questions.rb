class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text, presence: true
      t.integer :poll_id, presence: true

      t.timestamps
    end
  end
end
