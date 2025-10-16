class CreateExams < ActiveRecord::Migration[7.1]
  def change
    create_table :exams do |t|
      t.string :name, null: false
      t.text :description
      t.string :exam_type
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
    
    add_index :exams, :status
    add_index :exams, :exam_type
  end
end
