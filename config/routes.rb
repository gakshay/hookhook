Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/maalik', as: 'rails_admin'
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy'
  end

  resources :users do
    resources :requests do

    end
  end

  mount Split::Dashboard, :at => 'split'

  get 'home/:query' => 'home#user_lookup'

  root 'home#index'

  post '/add_request' => 'requests#create'
  delete '/request/:id' => 'requests#destroy'

  get '/:twitter_handle' => 'home#index', :as => 'home'

end
