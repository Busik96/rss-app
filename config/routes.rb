Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    omniauth_callbacks: 'omniauth_callbacks'
  }
  root to: "home#index"
end
