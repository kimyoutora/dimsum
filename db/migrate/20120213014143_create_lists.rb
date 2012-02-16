class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :original_text
      t.string :subject
      t.string :location
      t.string :category

      t.timestamps
    end
  end
end
