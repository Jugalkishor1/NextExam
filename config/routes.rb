Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  resources :exams, only: [:index, :show]
  
  resources :quizzes, only: [:index, :show] do
    member do
      post :start_attempt
      get :my_attempts
    end
  end

  resources :user_quiz_attempts, only: [:show, :update] do
    member do
      post :submit_quiz
      patch :save_answer
      get :solutions
    end
  end

  resources :mock_tests, only: [:index, :show] do
    member do
      post :start_attempt
      get :my_attempts
    end
  end

  resources :user_mock_test_attempts, only: [:show, :update] do
    member do
      post :submit_test
      patch :save_answer
      get :result
      get :solutions
    end
  end

  namespace :topic_wise do
    resources :subjects, only: [:index, :show]
    resources :topics, only: [:show]
  end
end
