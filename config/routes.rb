Capitalist::Application.routes.draw do
  resources :positions

  resources :purchases
  resources :sales
  resources :assets    
  root :to => "assets#index"
end
