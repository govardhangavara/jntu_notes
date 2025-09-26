class CreateNotes < ActiveRecord::Migration[7.2]
  def change
    create_table :notes do |t|
      t.string :title
      t.string :subject
      t.string :year
      t.string :branch

      t.timestamps
    end
  end
end
