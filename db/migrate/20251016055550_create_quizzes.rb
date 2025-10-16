class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.text :description
      t.references :subject, null: false, foreign_key: true
      t.integer :difficulty, default: 0, null: false
      t.integer :time_limit
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
    
    add_index :quizzes, :difficulty
    add_index :quizzes, :status
  end
end
