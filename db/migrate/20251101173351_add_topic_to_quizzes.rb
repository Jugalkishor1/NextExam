class AddTopicToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_reference :questions, :topic, foreign_key: true unless index_exists?(:questions, :topic_id)
    add_reference :quizzes, :topic, foreign_key: true unless index_exists?(:quizzes, :topic_id)
    
    add_index :questions, :topic_id unless index_exists?(:questions, :topic_id)
    add_index :quizzes, :topic_id unless index_exists?(:quizzes, :topic_id)
  end
end
