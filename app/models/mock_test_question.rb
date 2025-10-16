class MockTestQuestion < ApplicationRecord
  belongs_to :mock_test
  belongs_to :question
  
  validates :mock_test_id, presence: true
  validates :question_id, presence: true
  validates :mock_test_id, uniqueness: { scope: :question_id, message: "Question already added to this mock test" }
  validates :order, presence: true, numericality: { greater_than: 0 }
  
  default_scope { order(order: :asc) }
end
