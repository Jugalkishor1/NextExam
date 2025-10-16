class Question < ApplicationRecord
  enum question_type: { mcq: 0, multiple_answer: 1, true_false: 2 }
  
  belongs_to :quiz, optional: true
  belongs_to :exam, optional: true
  belongs_to :subject, optional: true
  
  has_many :options, dependent: :destroy
  has_many :mock_test_questions, dependent: :destroy
  has_many :mock_tests, through: :mock_test_questions
  has_many :user_answers, dependent: :destroy
  
  validates :content, presence: true
  validates :question_type, presence: true
  validates :marks, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: :all_blank
  
  def correct_option
    options.find_by(is_correct: true)
  end
  
  def correct_options
    options.where(is_correct: true)
  end
  
  def to_s
    content.truncate(50)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "exam_id", "id", "id_value", "marks", "question_type", "quiz_id", "subject_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["exam", "quiz", "subject"]
  end
end
