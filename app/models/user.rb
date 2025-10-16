class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :user_quiz_attempts, dependent: :destroy
  has_many :user_mock_test_attempts, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  
  has_many :attempted_quizzes, through: :user_quiz_attempts, source: :quiz
  has_many :attempted_mock_tests, through: :user_mock_test_attempts, source: :mock_test
  
  validates :email, presence: true, uniqueness: true
  
  def admin?
    admin == true
  end
  
  def to_s
    email
  end
end