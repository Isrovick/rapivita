Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "static#home"

  scope :api, defaults: { format: :json } do

    resources :sessions, only: [:create]
    post 'login', to: 'sessions#create', as: 'login'
    delete :logout, to: "sessions#logout"
    get :logged_in, to: "sessions#logged_in"

    resources :registrations, only: [:create]
    post 'signup', to: 'registrations#create', as: 'signup'

    resources :trans, only: [:create]
    get :getconv, to: 'trans#getconv'

end

end
