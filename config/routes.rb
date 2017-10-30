Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "authenticate", to: "authentication#authenticate"
  post "request_github_token", to: "users#request_github_token"

  get "repos", to: "projects#github_projects_list"

  get "projects/:id/issues", to: "issues#index"
  post "projects/:id/issues", to: "issues#create"
  put "projects/:id/issues", to: "issues#update"
  patch "projects/:id/issues", to: "issues#update"
  delete "projects/:id/issues", to: "issues#close"

  resources :users, shallow: true do
    resources :projects do
      resources :releases do
        resources :sprints do
          resources :stories
        end
      end
    end
  end
end
