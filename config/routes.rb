Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  resources :exams, only: [:index, :show]
  resources :quizzes, only: [:index, :show] do
    member do
      post :start_attempt  # Create new attempt
    end
  end

  resources :user_quiz_attempts, only: [:show, :update] do
    member do
      post :submit_quiz
      patch :save_answer
      get :result  # Add this route
    end
  end
end
