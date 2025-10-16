class Option < ApplicationRecord
  belongs_to :question
  has_many :user_answers, dependent: :destroy
  
  validates :content, presence: true
  validates :question_id, presence: true
  
  def to_s
    content
  end

  def self.ransackable_associations(auth_object = nil)
    ["question"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "is_correct", "question_id", "updated_at"]
  end
end
