class Subject < ApplicationRecord
  has_many :quizzes, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :topics, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "updated_at"]
  end
  
  def to_s
    name
  end
end
