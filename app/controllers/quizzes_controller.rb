class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz, only: [:show, :start_attempt]

  def index
    @subjects = Subject.all

    @quizzes = Quiz.includes(:subject)
                  .where(status: :published)
                  .order(created_at: :desc)

    if params[:subject_id].present?
      @quizzes = @quizzes.where(subject_id: params[:subject_id])
    end

    respond_to do |format|
      format.html # for full page load
      format.turbo_stream # for turbo updates
    end
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

  def my_attempts
    @quiz = Quiz.find(params[:id])
    @attempts = current_user.user_quiz_attempts
                           .where(quiz: @quiz)
                           .order(created_at: :desc)
                           .includes(:user_answers)
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end
end