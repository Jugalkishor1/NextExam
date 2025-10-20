class HomeController < ApplicationController
    before_action :authenticate_user!

  def index
    @exams = Exam.limit(3)
  end
end
