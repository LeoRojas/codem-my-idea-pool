Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'sessions#login'
  get '/login', to: 'sessions#login'
  get '/signup', to: 'sessions#signup'
end
