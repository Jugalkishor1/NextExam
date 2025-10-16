class CreateMockTestQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :mock_test_questions do |t|
      t.references :mock_test, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :order, null: false
      
      t.timestamps
    end
    
    add_index :mock_test_questions, [:mock_test_id, :question_id], unique: true
    add_index :mock_test_questions, [:mock_test_id, :order]
  end
end
