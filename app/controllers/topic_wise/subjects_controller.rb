module TopicWise
  class SubjectsController < ApplicationController
    before_action :authenticate_user!
    
    def index
      @subjects = Subject.includes(:topics)
                        .joins(:topics)
                        .where(topics: { status: :active })
                        .distinct
                        .order(:name)
    end
    
    def show
      @subject = Subject.includes(topics: :quizzes).find(params[:id])
      @topics = @subject.topics.active_topics.order(:name)
    end
  end
end
