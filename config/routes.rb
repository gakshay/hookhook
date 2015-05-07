Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/maalik', as: 'rails_admin'
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy'
  end

  resources :users do
    resources :requests
  end

  mount Split::Dashboard, :at => 'split'

  get 'home/:query' => 'home#user_lookup'

  root 'home#index'

  post '/add_request' => 'requests#create'
  delete '/request/:id' => 'requests#destroy'
  get '/:user_id/admirers' => 'requests#admirers', :as => 'user_admirers'

  get '/:user_id' => 'requests#index', :as => 'user_home'

end
