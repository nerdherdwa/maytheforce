Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'characters#index'

  resources :characters do
    collection { post :import }
  end

end
