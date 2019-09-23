Rails.application.routes.draw do
  resources :users, only: :show do
    post :login, on: :collection
  end
end
