class Topic < ApplicationRecord
  enum status: { active: 0, inactive: 1 }
  
  belongs_to :subject
  has_many :questions, dependent: :nullify
  has_many :quizzes, dependent: :destroy
  
  validates :name, presence: true
  validates :name, uniqueness: { scope: :subject_id, message: "already exists for this subject" }
  
  scope :active_topics, -> { where(status: :active) }
  scope :with_quizzes, -> { joins(:quizzes).distinct }
  
  def update_questions_count
    update(questions_count: questions.count)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "questions_count", "status", "subject_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["questions", "quizzes", "subject"]
  end
end