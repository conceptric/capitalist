Capitalist::Application.routes.draw do
  resources :assets

  resources :transactions
  resources :assets    
  root :to => "assets#index"
end
