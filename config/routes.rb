Rails.application.routes.draw do
  get 'static_pages/profile/:id', to: 'static_pages#profile', as: 'profile'
  resources :posts do
    resources :comments
  end

  devise_for :users

  root to: 'posts#index'
end
