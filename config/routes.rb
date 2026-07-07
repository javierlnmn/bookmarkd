Rails.application.routes.draw do
  resource :session
  resource :profile, only: [ :show, :update ] do
    delete :data, action: :destroy_data
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resources :folders do
    resources :folders, only: [ :new, :create ]
    resources :bookmarks, only: [ :new, :create ]
    resources :folder_collaborations, only: [ :new, :create, :destroy ], path: "collaborators"
  end

  resources :folders, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]

  get "shared" => "folder_collaborations#index", as: :shared_folders
  resources :bookmarks, only: [ :new, :create, :edit, :update, :destroy ]

  resources :tags, only: [ :create, :edit, :update, :destroy ]

  post "bookmark/:id/tag/:tag_id" => "bookmarks#tag", as: :tag_bookmark
  delete "bookmark/:id/untag/:tag_id" => "bookmarks#untag", as: :untag_bookmark

  get "folder/:id/move" => "folders#move_form", as: :move_folder_form
  put "folder/:id/move" => "folders#move", as: :move_folder

  root to: redirect("folders")
end
