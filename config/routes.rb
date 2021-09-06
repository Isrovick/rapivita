Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "static#home"

  scope :api, defaults: { format: :json } do

    resources :sessions, only: [:create]
    post 'login', to: 'sessions#create', as: 'login'
    delete :logout, to: "sessions#logout"
    post :logged_in, to: "sessions#logged_in"

    resources :registrations, only: [:create]
    post 'signup', to: 'registrations#create', as: 'signup'
    
    resources :balances
    post 'available', to: 'balances#getuserbals', as: 'available'

    resources :trans, only: [:create]
    get 'getrelresp', to: 'trans#getrelresp'
    post 'trade', to: 'trans#create', as: "trade"
    post 'rel', to: 'trans#getconvresp', as: "rel"
    post 'itran', to: 'trans#gettrans', as: "itran"
    post 'itrans', to: 'trans#getalltrans', as: "itrans"

end

end
