Rails.application.routes.draw do
  ## Braintree
  get 'braintree/new'
  get 'welcome/index'
  post 'braintree/checkout'
  root 'welcome#index'


  ##### Clearance Routes - Overwritten #####
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
      resources :locks, only: [:new, :create, :show, :edit, :destroy, :index]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
