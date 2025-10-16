class UserQuizAttempt < ApplicationRecord
  def self.ransackable_associations(auth_object = nil)
    ["quiz", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["completed_at", "created_at", "id", "id_value", "quiz_id", "score", "started_at", "status", "time_taken", "updated_at", "user_id"]
  end
  
  enum status: { in_progress: 0, completed: 1, abandoned: 2 }
  
  belongs_to :user
  belongs_to :quiz
  has_many :user_answers, dependent: :destroy
  
  validates :user_id, presence: true
  validates :quiz_id, presence: true
  validates :status, presence: true
  
  scope :completed_attempts, -> { where(status: :completed) }
  scope :recent, -> { order(created_at: :desc) }
  
  before_create :set_started_at
  
  def calculate_score
    correct_answers = user_answers.where(is_correct: true).count
    total_questions = quiz.questions.count
    return 0 if total_questions.zero?
    
    (correct_answers.to_f / total_questions * 100).round(2)
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
    quiz.questions.count
  end
  
  def percentage
    return 0 if total_questions.zero?
    (correct_answers_count.to_f / total_questions * 100).round(2)
  end
  
  private
  
  def set_started_at
    self.started_at ||= Time.current
  end
end
