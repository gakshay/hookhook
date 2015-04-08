Rails.application.routes.draw do
  resources :wishlists
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy'
  end

  root 'home#index'

end
