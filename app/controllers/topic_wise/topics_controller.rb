module TopicWise
  class TopicsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_topic
    
    def show
      @quizzes = @topic.quizzes
                      .where(status: :published)
                      .includes(:subject)
                      .order(created_at: :desc)
    end
    
    private
    
    def set_topic
      @topic = Topic.includes(:subject, :quizzes).find(params[:id])
    end
  end
end
