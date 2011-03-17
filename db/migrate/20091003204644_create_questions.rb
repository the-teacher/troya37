class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string  :zip

      t.string :from
      t.string :topic
      t.text :question
      t.text :answere

      t.text :contacts

      t.integer :user_id
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
