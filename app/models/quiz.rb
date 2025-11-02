class Quiz < ApplicationRecord
  enum difficulty: { easy: 0, medium: 1, hard: 2 }
  enum status: { published: 0, archived: 2 }
  
  belongs_to :subject
  belongs_to :topic, optional: true
  has_many :questions, dependent: :destroy
  has_many :user_quiz_attempts, dependent: :destroy
  
  validates :title, presence: true
  validates :difficulty, presence: true
  validates :subject_id, presence: true
  validates :status, presence: true
  
  scope :published_quizzes, -> { where(status: :published) }
  scope :by_difficulty, ->(difficulty) { where(difficulty: difficulty) if difficulty.present? }
  
  def to_s
    title
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "difficulty", "id", "id_value", "status", "subject_id", "time_limit", "title", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["questions", "subject", "topic"]
  end

  def quiz_attempt_for_user(user)
    user.user_quiz_attempts.find_by(quiz_id: self.id)
  end
end
