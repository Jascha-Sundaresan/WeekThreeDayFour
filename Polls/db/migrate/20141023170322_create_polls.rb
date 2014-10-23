class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title, presence: true, unique: true
      t.string :author, presence: true

      t.timestamps
    end
  end
end
