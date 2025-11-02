class CreateTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :topics do |t|
      t.string :name, null: false
      t.text :description
      t.references :subject, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.integer :questions_count, default: 0
      
      t.timestamps
    end
    
    add_index :topics, [:subject_id, :name], unique: true
    add_index :topics, :status
  end
end