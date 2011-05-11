Capitalist::Application.routes.draw do
  resources :purchases
  resources :assets    
  root :to => "assets#index"
end
