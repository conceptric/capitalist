Capitalist::Application.routes.draw do
  shallow do
    resources :assets do
      resources :positions do
        resources :purchases, :sales
      end
    end
  end
  root :to => "assets#index"
end
