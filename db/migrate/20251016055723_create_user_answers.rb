class CreateUserAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :option, foreign_key: true # can be null for descriptive questions
      t.references :user_quiz_attempt, foreign_key: true
      t.references :user_mock_test_attempt, foreign_key: true
      t.boolean :is_correct
      t.text :answer_text
      
      t.timestamps
    end
  end
end
