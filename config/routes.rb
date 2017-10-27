Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "authenticate", to: "authentication#authenticate"
  post "request_github_token", to: "users#request_github_token"

  get "repos", to: "projects#github_projects_list"

  resources :users, shallow: true do
    resources :projects do
      resources :releases do
      end
      resources :sprints
    end
  end
end
