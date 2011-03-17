class ReportsAddSeoFields < ActiveRecord::Migration
  def self.up
    add_column :reports, :author,       :text
    add_column :reports, :keywords,     :text
    add_column :reports, :description,  :text
    add_column :reports, :copyright,    :text
    add_column :reports, :head,         :text
    add_column :reports, :header,       :text
    add_column :reports, :footer,       :text
  end

  def self.down
    remove_column :reports, :author
    remove_column :reports, :keywords
    remove_column :reports, :description
    remove_column :reports, :copyright
    remove_column :reports, :head
    remove_column :reports, :header
    remove_column :reports, :footer
  end
end
