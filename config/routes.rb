Rails.application.routes.draw do
  resources :subscribers, :only => [:create]
  mount RailsAdmin::Engine => '/maalik', as: 'rails_admin'
  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'}
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy'
  end

  match '/delayed_job' => DelayedJobWeb, :anchor => false, via: [:get, :post]

  resources :users do
    resources :notifications do
      collection do
        put :mark_all_as_read
      end
    end

    resources :requests do
      member do
        get :like, :publish_me, :help
      end
    end
  end

  resources :conversations do
    resources :messages
  end

  mount Split::Dashboard, :at => 'split'

  get 'home/:query' => 'home#user_lookup'

  root 'home#index'

  post '/add_request' => 'requests#create'
  post '/add_to_my_list' => 'requests#add_to_my_list'
  delete '/request/:id' => 'requests#destroy'
  get '/:user_id/admirers' => 'requests#admirers', :as => 'user_admirers'
  get '/:user_id/conversations' => 'requests#conversations', :as => 'user_conversations'
  get '/:user_id/admirers_report' => "reports#admirers", :as => "user_admirers_report"

  get '/:user_id' => 'requests#index', :as => 'user_home'
  get '/:user_id/landing' => 'home#show', :as => 'landing_user_home'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/:id/username' => 'users#username', via: [:put], :as => :username
end
