class UserMockTestAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :mock_test
  has_many :user_answers, dependent: :destroy
  
  enum status: { in_progress: 0, completed: 1, abandoned: 2 }
  
  validates :started_at, presence: true
  scope :completed_attempts, -> { where(status: :completed) }
  
  def time_remaining
    return 0 if completed?
    
    time_limit_seconds = mock_test.duration * 60
    elapsed_seconds = (Time.current - started_at).to_i
    remaining = time_limit_seconds - elapsed_seconds
    
    [remaining, 0].max
  end
  
  def percentage_score
    questions = mock_test.mock_test_questions.includes(:question)
    return 0 if questions.empty?
    
    total_marks = questions.sum { |mtq| mtq.question.marks }
    return 0 if total_marks.zero?
    
    
    ((score.to_i / total_marks) * 100).round(2)
  end
  
  def total_questions
    mock_test.mock_test_questions.count
  end
end