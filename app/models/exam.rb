class Exam < ApplicationRecord
  enum status: { draft: 0, published: 1, archived: 2 }
  
  has_many :mock_tests, dependent: :destroy
  has_many :questions, dependent: :destroy
  
  validates :name, presence: true
  validates :status, presence: true
  
  scope :published_exams, -> { where(status: :published) }
  
  def to_s
    name
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "exam_type", "id", "id_value", "name", "status", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    []
  end
end