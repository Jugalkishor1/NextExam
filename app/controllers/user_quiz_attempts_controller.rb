class UserQuizAttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attempt, only: [:show, :save_answer, :submit_quiz, :result]
  before_action :check_attempt_status, only: [:show, :save_answer]

  def show
    @quiz = @attempt.quiz
    @questions = @quiz.questions.includes(:options).order(:id)
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

  def submit_quiz
    # Calculate score
    total_marks = 0
    correct_answers = 0
    
    @attempt.quiz.questions.each do |question|
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
    
    redirect_to result_user_quiz_attempt_path(@attempt), 
                notice: "Quiz submitted successfully!"
  end

  def result
    @attempt = current_user.user_quiz_attempts.find(params[:id])
    @quiz = @attempt.quiz
    @questions = @quiz.questions
    @user_answers = @attempt.user_answers 
  end

  private

  def set_attempt
    @attempt = current_user.user_quiz_attempts.find(params[:id])
  end

  def check_attempt_status
    if @attempt.completed?
      redirect_to result_user_quiz_attempt_path(@attempt), 
                  alert: "This quiz has already been completed."
    end
  end
end