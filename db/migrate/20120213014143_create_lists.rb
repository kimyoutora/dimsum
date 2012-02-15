class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :subject
      t.string :location

      t.timestamps
    end
  end
end
