class UserQuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  has_many :user_answers, dependent: :destroy
  
  enum status: { in_progress: 0, completed: 1, abandoned: 2 }
  
  validates :started_at, presence: true
  
  def time_remaining
    return 0 if completed?
    
    time_limit_seconds = quiz.time_limit * 60
    elapsed_seconds = (Time.current - started_at).to_i
    remaining = time_limit_seconds - elapsed_seconds
    
    [remaining, 0].max
  end
  
  def percentage_score
    return 0 if quiz.questions.empty?
    
    total_marks = quiz.questions.sum(:marks)
    return 0 if total_marks.zero?
    
    ((score / total_marks) * 100).round(2)
  end
end