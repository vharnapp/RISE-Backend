Rails.application.routes.draw do
  resources :workouts
  resources :phases
  resources :pyramid_modules
  resources :clubs do
    resources :teams
  end

  resources :teams

  devise_for :users, controllers: {
    registrations: 'devise_customizations/registrations',
    sessions: 'devise_customizations/sessions',
  }

  resources :users do
    member do
      get 'analytics_alias'
    end
  end

  namespace :admin do
    resources :pyramid_modules
    resources :phases
    resources :workouts

    resources :users do
      member do
        get 'impersonate'
      end

      collection do
        get 'stop_impersonating'
      end
    end

    root to: "users#index"
  end

  authenticated :user do
    # root to: 'dashboard#show', as: :authenticated_root
    root to: 'high_voltage/pages#show', id: 'welcome', as: :authenticated_root
  end

  devise_scope :user do
    get 'sign-in',  to: 'devise/sessions#new'
    get 'sign-out', to: 'devise/sessions#destroy'

    # API-token creation aliases
    post 'api/v1/sign_in', to: 'devise_customizations/sessions#create'
    get 'api/v1/sign_out', to: 'devise_customizations/sessions#destroy'
  end
  root 'high_voltage/pages#show', id: 'welcome'

  namespace 'api' do
    namespace 'v1' do
      jsonapi_resources :users do
        # jsonapi_resources :posts
        # jsonapi_links :posts
      end
    end
  end
end
