Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'

  resources :releases
  resources :users
  resources :projects

  get 'users/:id/projects' => 'projects#index'
  post 'users/:id/projects' => 'projects#create'
  get 'users/:id/projects/:id/releases' => 'releases#index'
  post 'users/:id/projects/:id/releases' => 'releases#create'

end
