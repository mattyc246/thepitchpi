Rails.application.routes.draw do

  ## Twilio sms
  post 'twilio/sms'
  ## Braintree
  get 'subscription/new' => "braintree#new", as: "subscription_new"
  post 'braintree/new'
  get 'welcome/index'
  post 'subscription/checkout' => 'braintree#checkout', as: "subscription_checkout"
  root 'welcome#index'
  get 'locks/status_check' =>  'locks#status_check', as: "status_check"
  get 'locks/distance_check' =>  'locks#distance_check', as: "distance_check"
  get 'locks/toggle_lock' => 'locks#toggle_lock', as: "toggle_lock"

  get 'locks/group_points' => 'locks#group_points', as: "group_points"

  get 'easter_egg' => 'welcome#easter_egg', as: "easter_egg"
  get 'merch' => 'welcome#merch', as:"merch"


  get 'lock_around_the_clock' => 'locks#lock_around_the_clock', as: "latc"
  ##### Clearance Routes - Overwritten #####
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
      resources :locks, only: [:new, :update, :create, :show, :edit, :destroy, :index]
  end



  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
