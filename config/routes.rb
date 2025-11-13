Rails.application.routes.draw do
  devise_for :users, path: "/api/v1", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
  sessions: "api/v1/auth/sessions",
  registrations: "api/v1/auth/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api  do
    namespace :v1 do
      get "up" => "health_check#show", as: :rails_health_check
      resources :vehicles
      resources :rentals, except: [ :index ]
    end
  end
end
