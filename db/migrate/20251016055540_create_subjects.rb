class CreateSubjects < ActiveRecord::Migration[7.1]
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.text :description
      
      t.timestamps
    end
    
    add_index :subjects, :name, unique: true
  end
end
