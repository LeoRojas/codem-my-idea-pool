Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'sessions#login'

  get '/login', to: 'sessions#login'
  get '/signup', to: 'sessions#signup'
  post '/access-tokens', to: 'sessions#create'
  post '/access-tokens/refresh', to: 'sessions#access_tokens_refresh'
  delete '/access-tokens', to: 'sessions#destroy'

  get '/me', to: 'users#me'
  post '/users', to: 'users#create'

  get '/ideas', to: 'ideas#index'
  post '/ideas', to: 'ideas#create'
  put '/ideas/:id', to: 'ideas#update'
  delete '/ideas/:id', to: 'ideas#destroy'

end