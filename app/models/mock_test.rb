class MockTest < ApplicationRecord
  enum status: { draft: 0, published: 1, archived: 2 }
  
  belongs_to :exam
  has_many :mock_test_questions, -> { order(order: :asc) }, dependent: :destroy
  has_many :questions, through: :mock_test_questions
  has_many :user_mock_test_attempts, dependent: :destroy
  
  validates :title, presence: true
  validates :exam_id, presence: true
  validates :status, presence: true
  validates :duration, numericality: { greater_than: 0 }, allow_nil: true
  
  scope :published_tests, -> { where(status: :published) }
  
  def calculate_total_marks
    questions.sum(:marks)
  end
  
  def questions_count
    questions.count
  end
  
  def to_s
    title
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "duration", "exam_id", "id", "id_value", "status", "title", "total_marks", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["exam"]
  end
end
