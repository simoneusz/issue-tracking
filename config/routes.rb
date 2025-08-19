Rails.application.routes.draw do
  devise_for :users

  root "projects#index"

  resources :projects do
    resources :issues do
      resources :comments, only: [:create, :destroy]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
