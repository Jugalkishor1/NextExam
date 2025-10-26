class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz, only: [:show, :start_attempt]

  def index
    @quizzes = Quiz.includes(:subject)
                   .where(status: :published)
                   .order(created_at: :desc)
  end

  def show
    @quiz = Quiz.includes(:subject, :questions).find(params[:id])
  end

  def start_attempt
    # Check if user has a previous attempt for this quiz
    existing_attempt = current_user.user_quiz_attempts.find_by(quiz: @quiz)

    if existing_attempt.present?
      # Remove old attempt before creating a new one
      existing_attempt.destroy
    end

    # Create new attempt
    @attempt = current_user.user_quiz_attempts.create!(
      quiz: @quiz,
      status: :in_progress,
      started_at: Time.current
    )

    redirect_to user_quiz_attempt_path(@attempt)
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end
end