Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post '/auth/google_login', to: 'sessions#google_login'
  post '/auth/refresh_token', to: 'sessions#refresh_token'
  get '/auth/test', to: 'test#test_coi'
  # authenticate :jwt_middleware do
  #   post '/auth/google_login2', to: 'sessions#google_login2'
  # end

  get '/courses', to: 'courses#index'
  post '/course', to: 'courses#create'
  put '/course/:id', to: 'courses#update'
  get '/course/:id', to: 'courses#show'
  delete '/course/:id', to: 'courses#destroy'

end
