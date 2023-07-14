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

  get 'videos', to: 'videos#index'
  get 'videos/:file_name', to: 'videos#show', as: 'video_detail'
  get 'videos/create', to: 'videos#create', as: 'video_create'
  post 'videos/store', to: 'videos#store'
end
