class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.integer :question_type, default: 0, null: false
      t.decimal :marks, precision: 5, scale: 2, default: 1.0
      t.references :quiz, foreign_key: true
      t.references :exam, foreign_key: true
      t.references :subject, foreign_key: true
      
      t.timestamps
    end
    
    add_index :questions, :question_type
  end
end
