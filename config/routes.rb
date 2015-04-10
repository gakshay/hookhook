Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy'
  end

  get 'home/:query' => 'home#user_lookup'

  root 'home#index'

  post '/add_request' => 'request#create'
  get '/:twitter_handle' => 'home#index', :as => "home"

end
