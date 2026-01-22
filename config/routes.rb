Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect("/bookmarks")

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  get "/bookmarks", to: "bookmarks#index"
  get "/bookmarks/new", to: "bookmarks#new"
  post "/bookmarks/create", to: "bookmarks#create"
  get "/bookmarks/edit", to: "bookmarks#edit"
  put "/bookmarks/update", to: "bookmarks#update"

  get "/folders/new", to: "folders#new"
  post "/folders/create", to: "folders#create"
  get "/folders/edit", to: "folders#edit"
  put "/folders/update", to: "folders#update"
end
