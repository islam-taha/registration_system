Rails.application.routes.draw do
  # Registrations
  get  'users/sign_up', to: 'registrations#new',    as: :registration
  post 'users/sign_up', to: 'registrations#create', as: :new_registration
end
