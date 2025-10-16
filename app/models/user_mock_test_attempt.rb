class UserMockTestAttempt < ApplicationRecord
  def self.ransackable_associations(auth_object = nil)
    ["mock_test", "user"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["completed_at", "created_at", "id", "id_value", "mock_test_id", "score", "started_at", "status", "time_taken", "updated_at", "user_id"]
  end
  
  enum status: { in_progress: 0, completed: 1, abandoned: 2 }
  
  belongs_to :user
  belongs_to :mock_test
  has_many :user_answers, dependent: :destroy
  
  validates :user_id, presence: true
  validates :mock_test_id, presence: true
  validates :status, presence: true
  
  scope :completed_attempts, -> { where(status: :completed) }
  scope :recent, -> { order(created_at: :desc) }
  
  before_create :set_started_at
  
  def calculate_score
    total_marks = 0
    user_answers.includes(:question).each do |answer|
      total_marks += answer.question.marks if answer.is_correct
    end
    total_marks
  end
  
  def mark_completed!
    update!(
      status: :completed,
      completed_at: Time.current,
      time_taken: calculate_time_taken,
      score: calculate_score
    )
  end
  
  def calculate_time_taken
    return nil unless started_at
    (Time.current - started_at).to_i
  end
  
  def correct_answers_count
    user_answers.where(is_correct: true).count
  end
  
  def total_questions
    mock_test.questions.count
  end
  
  def total_marks
    mock_test.total_marks || 0
  end
  
  def percentage
    return 0 if total_marks.zero?
    (score.to_f / total_marks * 100).round(2)
  end
  
  private
  
  def set_started_at
    self.started_at ||= Time.current
  end
end
