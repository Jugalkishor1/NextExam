class MockTestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mock_test, only: [:show, :start_attempt]

  def index
    @mock_tests = MockTest.includes(:exam)
                          .where(status: :published)
                          .order(created_at: :desc)
  end

  def show
    @mock_test = MockTest.includes(:exam, :mock_test_questions => {:question => :options})
                        .find(params[:id])
    @questions_count = @mock_test.mock_test_questions.count
  end

  def start_attempt
    # Create new mock test attempt
    @attempt = current_user.user_mock_test_attempts.create!(
      mock_test: @mock_test,
      status: :in_progress,
      started_at: Time.current
    )
    
    redirect_to user_mock_test_attempt_path(@attempt)
  end

  def my_attempts
    @mock_test = MockTest.find(params[:id])
    @attempts = current_user.user_mock_test_attempts
                           .where(mock_test: @mock_test)
                           .order(created_at: :desc)
                           .includes(:user_answers)
  end

  private

  def set_mock_test
    @mock_test = MockTest.find(params[:id])
  end
end
