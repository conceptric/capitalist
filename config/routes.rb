Capitalist::Application.routes.draw do
  resources :transactions
  resources :assets    
  root :to => "assets#index"
end
