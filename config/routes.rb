Rails.application.routes.draw do
  get 'karte/index'

  resources :leagues, only: [:index, :create]

  get 'leagues/index'

  get 'welcome/index'

  root 'welcome#index'
end
