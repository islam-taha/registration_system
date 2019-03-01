Rails.application.routes.draw do
  root to: 'users#show'

  # Registrations
  get  'users/sign_up', to: 'registrations#new',    as: :registration
  post 'users/sign_up', to: 'registrations#create', as: :new_registration

  # Sessions
  get    'users/sign_in',  to: 'sessions#new',     as: :session
  post   'users/sign_in',  to: 'sessions#create',  as: :new_session
  delete 'users/sign_out', to: 'sessions#destroy', as: :destroy_session

  # Profile
  get 'profile', to: 'users#show',   as: :profile
  put 'profile', to: 'users#update', as: :update_profile
end
