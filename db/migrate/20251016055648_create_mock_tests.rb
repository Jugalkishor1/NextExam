class CreateMockTests < ActiveRecord::Migration[7.1]
  def change
    create_table :mock_tests do |t|
      t.string :title, null: false
      t.text :description
      t.references :exam, null: false, foreign_key: true
      t.integer :duration
      t.decimal :total_marks, precision: 6, scale: 2
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
    
    add_index :mock_tests, :status
  end
end
