class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :title
      t.text :annotation
      t.text :content

      t.integer :user_id
      t.string :state
      
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
