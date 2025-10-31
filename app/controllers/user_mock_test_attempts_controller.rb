class UserMockTestAttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attempt, only: [:show, :save_answer, :submit_test, :result, :solutions]
  before_action :check_attempt_status, only: [:show, :save_answer]
  before_action :check_attempt_completed, only: [:result, :solutions]

  def show
    @mock_test = @attempt.mock_test
    @questions = @mock_test.mock_test_questions
                          .includes(question: :options)
                          .order(:order)
                          .map(&:question)
    @user_answers = @attempt.user_answers.index_by(&:question_id)
  end

  def save_answer
    question = Question.find(params[:question_id])
    option = Option.find_by(id: params[:option_id])
    
    # Find or create user answer
    user_answer = @attempt.user_answers.find_or_initialize_by(
      user_id: current_user.id,
      question_id: question.id
    )
    
    user_answer.option_id = option&.id
    user_answer.is_correct = option&.is_correct
    user_answer.save!
    
    render json: { 
      success: true, 
      question_id: question.id,
      option_id: option&.id 
    }
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def submit_test
    # Calculate score
    total_marks = 0
    correct_answers = 0
    
    @attempt.mock_test.mock_test_questions.each do |mtq|
      question = mtq.question
      user_answer = @attempt.user_answers.find_by(question_id: question.id)
      if user_answer&.is_correct
        total_marks += question.marks
        correct_answers += 1
      end
    end
    
    # Calculate time taken
    time_taken = ((Time.current - @attempt.started_at) / 60).to_i # in minutes
    
    # Update attempt
    @attempt.update!(
      status: :completed,
      completed_at: Time.current,
      score: total_marks,
      time_taken: time_taken
    )
    
    redirect_to result_user_mock_test_attempt_path(@attempt), 
                notice: "Mock test submitted successfully!"
  end

  def result
    @mock_test = @attempt.mock_test
    @questions = @mock_test.mock_test_questions
                          .includes(question: :options)
                          .order(:order)
                          .map(&:question)
    @user_answers = @attempt.user_answers.includes(:option, :question).index_by(&:question_id)
  end

  def solutions
    @mock_test = @attempt.mock_test
    @questions = @mock_test.mock_test_questions
                          .includes(question: :options)
                          .order(:order)
                          .map(&:question)
    @user_answers = @attempt.user_answers.includes(:option, :question).index_by(&:question_id)
  end

  private

  def set_attempt
    @attempt = current_user.user_mock_test_attempts.find(params[:id])
  end

  def check_attempt_status
    if @attempt.completed?
      redirect_to result_user_mock_test_attempt_path(@attempt), 
                  alert: "This mock test has already been completed."
    end
  end
  
  def check_attempt_completed
    unless @attempt.completed?
      redirect_to user_mock_test_attempt_path(@attempt),
                  alert: "Please complete the mock test first."
    end
  end
end
