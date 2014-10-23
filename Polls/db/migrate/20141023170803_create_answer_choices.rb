class CreateAnswerChoices < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.string :text, presence: true
      t.integer :question_id, presence: true

      t.timestamps
    end
  end
end
