Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products do
      resources :variants do
        resources :sale_prices
      end
      resources :sale_prices
    end
  end
end
