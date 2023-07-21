Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post '/auth/google_login', to: 'sessions#google_login'
  post '/auth/refresh_token', to: 'sessions#refresh_token'
  get '/auth/get_info_by_token', to: 'users#get_info_by_token'
  post '/auth/logout', to: 'users#logout'
  get '/auth/test', to: 'test#test_coi'

  get '/courses', to: 'courses#index'
  post '/course', to: 'courses#create'
  put '/course/:id', to: 'courses#update'
  get '/course/:id', to: 'courses#show'
  delete '/course/:id', to: 'courses#destroy'
  

  get 'videos', to: 'videos#index'
  get 'videos/:file_name', to: 'videos#show', as: 'video_detail'
  get 'videos/create', to: 'videos#create', as: 'video_create'
  post 'videos/store', to: 'videos#store'

  post 'upload_videos/store', to: 'upload_videos#store'
  put 'upload_videos/:id', to: 'upload_videos#update'

  post 'images/upload', to: 'images#upload'
  get 'images/list', to: 'images#list_folders'

  post 'chapter', to: 'chapters#create'
  get 'chapters', to: 'chapters#index'
  put '/chapter/:id', to: 'chapters#update'
  get '/chapter/:id', to: 'chapters#show'
  delete '/chapter/:id', to: 'chapters#destroy'

end
