Rails.application.routes.draw do
  devise_for :users

  resources :calculations, only: [:new, :create, :show, :destroy] do
    member do
      get :download_pdf
    end
  end

  get "/dashboard", to: "dashboard#index", as: :dashboard

  namespace :admin do
    resources :users, only: [:index] do
      member do
        patch :suspend
        patch :reactivate
      end
    end
  end

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end
end
