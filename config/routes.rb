Rails.application.routes.draw do
  resources :clubs, only: [:show, :edit, :update] do
    resources :teams, only: [:index, :show, :edit, :update]
  end

  devise_for :users, controllers: {
    registrations: 'devise_customizations/registrations',
    sessions: 'devise_customizations/sessions',
  }

  resources :users do
    member do
      get 'analytics_alias'
    end
  end

  post 'versions/:id/revert' => 'versions#revert', as: 'revert_version'
  namespace :admin do
    put 'sort' => 'application#sort'

    resources :pyramid_modules
    resources :phases
    resources :workouts
    resources :exercises
    resources :clubs
    resources :teams
    resources :affiliations
    resources :enrollments
    resources :subscriptions
    resources :temp_teams

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
      jsonapi_resources :pyramid_modules do
        jsonapi_resources :phases do
          jsonapi_resources :workouts do
            jsonapi_resources :exercises
          end
        end
      end
      jsonapi_resources :users do
        jsonapi_resources :teams
      end

      jsonapi_resources :confidence_ratings
      jsonapi_resources :unlocked_pyramid_modules
      jsonapi_resources :phase_attempts
      jsonapi_resources :affiliations
      jsonapi_resources :teams
      jsonapi_resources :clubs
    end
  end
end
