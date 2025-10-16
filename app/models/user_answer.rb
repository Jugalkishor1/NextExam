class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :option, optional: true
  belongs_to :user_quiz_attempt, optional: true
  belongs_to :user_mock_test_attempt, optional: true
  
  validates :user_id, presence: true
  validates :question_id, presence: true
  
  before_save :check_correctness
  
  def correct_answer
    question.correct_option
  end
  
  private
  
  def check_correctness
    return unless option.present?
    
    if question.mcq? || question.true_false?
      self.is_correct = option.is_correct
    elsif question.multiple_answer?
      correct_option_ids = question.options.where(is_correct: true).pluck(:id).sort
      
      if user_quiz_attempt.present?
        user_option_ids = user_quiz_attempt.user_answers.where(question: question).pluck(:option_id).sort
      elsif user_mock_test_attempt.present?
        user_option_ids = user_mock_test_attempt.user_answers.where(question: question).pluck(:option_id).sort
      else
        user_option_ids = [option.id]
      end
      
      self.is_correct = correct_option_ids == user_option_ids
    end
  end
end