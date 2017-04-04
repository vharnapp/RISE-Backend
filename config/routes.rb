Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'devise_customizations/registrations',
  }

  resources :users do
    member do
      get 'analytics_alias'
    end
  end

  namespace :admin do
    resources :users do
      member do
        get 'impersonate'
      end

      collection do
        get 'stop_impersonating'
      end
    end
  end

  authenticated :user do
    # root to: 'dashboard#show', as: :authenticated_root
    root to: 'high_voltage/pages#show', id: 'welcome', as: :authenticated_root
  end

  devise_scope :user do
    get 'sign-in',  to: 'devise/sessions#new'
    get 'sign-out', to: 'devise/sessions#destroy'
  end
  root 'high_voltage/pages#show', id: 'welcome'

  # API-specific routes
  namespace 'api' do
    namespace 'v1' do
      resources :users, except: [:new, :edit]
    end
  end
end
