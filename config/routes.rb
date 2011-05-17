Capitalist::Application.routes.draw do
  resources :sales
  shallow do
    resources :assets do
      resources :positions do
        resources :purchases
      end
    end
  end
  root :to => "assets#index"
end
