Rails.application.routes.draw do
  root 'locations#index'
  resources :locations, only: [:new, :create, :show, :index]
end
