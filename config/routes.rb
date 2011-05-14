Capitalist::Application.routes.draw do
  resources :purchases, :sales
  shallow do
    resources :assets do
      resources :positions
    end
  end
  root :to => "assets#index"
end
