class AddTopicToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_reference :questions, :topic, foreign_key: true
    add_reference :quizzes, :topic, foreign_key: true
  end
end
