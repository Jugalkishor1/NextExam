class ExamsController < ApplicationController
  def index
    @exams = Exam.published_exams.order(:name)
  end

  def show
    @exam = Exam.published_exams.find(params[:id])
    @mock_tests = @exam.mock_tests.published_tests.order(:title)
    @subjects = @exam.questions.includes(:subject).map(&:subject).compact.uniq
    @total_questions = @exam.questions.count
    @recent_attempts = @exam.mock_tests
                            .joins(:user_mock_test_attempts)
                            .merge(UserMockTestAttempt.completed_attempts)
                            .includes(:user)
                            .order('user_mock_test_attempts.completed_at DESC')
                            .limit(5)
  end

  def mock_tests
    @exam = Exam.published_exams.find(params[:id])
    @mock_tests = @exam.mock_tests.published_tests.order(:title)
  end
end